#!/usr/bin/env python3
import os
import sys

# Force X11 backend so set_wmclass works reliably for Hyprland rules
os.environ["GDK_BACKEND"] = "x11"

import gi
import subprocess

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk, GLib

# Set prgname so Hyprland correctly identifies the class/app_id
GLib.set_prgname("hyprsunset-gui")
GLib.set_application_name("hyprsunset-gui")

TEMP_FILE = "/tmp/hyprsunset_current_temp"

def get_current_temp():
    if os.path.exists(TEMP_FILE):
        try:
            with open(TEMP_FILE, 'r') as f:
                return int(f.read().strip())
        except:
            return 4000
    return 4000

def set_temp(val):
    with open(TEMP_FILE, 'w') as f:
        f.write(str(int(val)))

def apply_hyprsunset(val):
    val = int(val)
    set_temp(val)
    # Restart hyprsunset with new value
    subprocess.run(["pkill", "-x", "hyprsunset"])
    subprocess.Popen(["hyprsunset", "-t", str(val)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

class SliderWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title="Hyprsunset Temp")
        # Ensure the class matches our Hyprland rule
        self.set_wmclass("hyprsunset-gui", "hyprsunset-gui")
        self.set_role("hyprsunset-gui")
        self.set_type_hint(Gdk.WindowTypeHint.DIALOG)
        
        # Window Dimensions
        width = 300
        height = 60
        self.set_default_size(width, height)
        
        # Position under mouse
        self.move_to_mouse(width)

        # Close on Escape
        self.connect("key-press-event", self.on_key_press)
        
        # Force Dark Theme CSS
        css = b"""
        window { background-color: #1e1e2e; color: #cdd6f4; }
        scale { margin: 0px; }
        label { font-weight: bold; font-size: 16px; color: #cdd6f4; }
        """
        provider = Gtk.CssProvider()
        provider.load_from_data(css)
        Gtk.StyleContext.add_provider_for_screen(Gdk.Screen.get_default(), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

        main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=5)
        main_box.set_margin_top(15)
        main_box.set_margin_bottom(15)
        main_box.set_margin_start(15)
        main_box.set_margin_end(15)
        self.add(main_box)

        # Label
        self.label = Gtk.Label()
        self.update_label(get_current_temp())
        main_box.pack_start(self.label, False, False, 0)

        # Slider: lower=1000, upper=10000, step=5
        self.adj = Gtk.Adjustment(value=get_current_temp(), lower=1000, upper=10000, step_increment=5, page_increment=50, page_size=0)
        self.scale = Gtk.Scale(orientation=Gtk.Orientation.HORIZONTAL, adjustment=self.adj)
        self.scale.set_draw_value(False)
        self.scale.set_round_digits(0)
        
        # Connect signals
        self.scale.connect("value-changed", self.on_value_changed)
        self.scale.connect("button-release-event", self.on_scale_release)
        main_box.pack_start(self.scale, True, True, 0)

        self.show_all()

    def move_to_mouse(self, win_width):
        display = Gdk.Display.get_default()
        seat = display.get_default_seat()
        pointer = seat.get_pointer()
        screen, x, y = pointer.get_position()
        
        # Center horizontally on mouse, place just below bar (approx 35px)
        # Check if near right edge
        screen_width = screen.get_width()
        final_x = x - (win_width // 2)
        
        # Simple bounds check
        if final_x + win_width > screen_width:
            final_x = screen_width - win_width - 10
        if final_x < 0:
            final_x = 10
            
        self.move(final_x, 35)

    def update_label(self, val):
        self.label.set_markup(f"<span size='large'><b>{int(val)}K</b></span>")

    def on_value_changed(self, scroll):
        val = self.scale.get_value()
        # Snap to nearest 5
        snapped = round(val / 5) * 5
        if snapped != val:
            self.scale.set_value(snapped)
        self.update_label(snapped)

    def on_scale_release(self, widget, event):
        val = widget.get_value()
        apply_hyprsunset(val)
        return False

    def on_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            Gtk.main_quit()

if __name__ == "__main__":
    win = SliderWindow()
    win.connect("destroy", Gtk.main_quit)
    Gtk.main()
