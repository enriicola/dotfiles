import os
import requests
import platform
from bs4 import BeautifulSoup

# --- CONFIGURATION ---
# The file you uploaded (must be in the same folder as this script)
HTML_FILENAME = "plugins.html"
# ---------------------

def get_plugins_dir():
    """Detects the qBittorrent search engine folder."""
    system = platform.system()
    home = os.path.expanduser("~")
    
    if system == "Windows":
        return os.path.join(os.environ["LOCALAPPDATA"], "qBittorrent", "nova3", "engines")
    elif system == "Darwin": # macOS
        return os.path.join(home, "Library", "Application Support", "qBittorrent", "nova3", "engines")
    else: # Linux
        paths = [
            os.path.join(home, ".local", "share", "qBittorrent", "nova3", "engines"),
            os.path.join(home, ".var", "app", "org.qbittorrent.qBittorrent", "data", "qBittorrent", "nova3", "engines")
        ]
        for p in paths:
            if os.path.exists(os.path.dirname(p)):
                return p
        return paths[0]

def to_raw_url(url):
    """Converts GitHub 'blob' links to 'raw' download links."""
    if "github.com" in url and "/blob/" in url:
        return url.replace("github.com", "raw.githubusercontent.com").replace("/blob/", "/")
    return url

def install():
    save_dir = get_plugins_dir()
    
    # 1. Check if HTML file exists
    if not os.path.exists(HTML_FILENAME):
        print(f"❌ Error: Could not find file: '{HTML_FILENAME}'")
        print("   Make sure the HTML file is in the SAME folder as this script.")
        return

    # 2. Parse the HTML
    print(f"📂 Reading: {HTML_FILENAME}...")
    try:
        with open(HTML_FILENAME, "r", encoding="utf-8", errors="ignore") as f:
            soup = BeautifulSoup(f, "html.parser")
    except Exception as e:
        print(f"❌ Error reading file: {e}")
        return

    # 3. Find all links ending in .py
    links = soup.find_all('a', href=True)
    plugin_urls = set()

    for link in links:
        href = link['href']
        if href.endswith(".py"):
            # Fix relative links
            if href.startswith("/"):
                href = "https://github.com" + href
            
            plugin_urls.add(to_raw_url(href))

    print(f"⚡ Found {len(plugin_urls)} plugins. Installing to: {save_dir}\n")

    if not os.path.exists(save_dir):
        try:
            os.makedirs(save_dir)
        except OSError:
            print(f"❌ Error: Could not create folder {save_dir}")
            return

    # 4. Download Loop
    success = 0
    headers = {'User-Agent': 'Mozilla/5.0'}

    for url in plugin_urls:
        filename = url.split('/')[-1]
        file_path = os.path.join(save_dir, filename)

        try:
            r = requests.get(url, headers=headers, timeout=10)
            if r.status_code == 200:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(r.text)
                print(f"✅ Installed: {filename}")
                success += 1
            else:
                print(f"⚠️  Skipped (Bad Link): {filename}")
        except Exception:
            print(f"❌ Failed to download: {filename}")

    print(f"\n🎉 Finished! Installed {success} plugins.")
    print("👉 Restart qBittorrent to apply changes.")

if __name__ == "__main__":
    install()
