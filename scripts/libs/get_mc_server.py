import json
import urllib.request
import argparse

parser = argparse.ArgumentParser(description="Get Minecraft server download URL for a specific version.")
parser.add_argument("version", type=str, help="Minecraft version to get the server URL for")
args = parser.parse_args()

target_version = args.version

url = "https://piston-meta.mojang.com/mc/game/version_manifest.json"
with urllib.request.urlopen(url) as response:
    version_data = json.loads(response.read().decode('utf-8'))

url = ""
for d in version_data["versions"]:
    if d["id"] == target_version:
        url = d["url"]
        break
else:
    print("Version not found.")

# JSON APIから取得して文字列として保持
with urllib.request.urlopen(url) as response:
    data = json.loads(response.read().decode('utf-8'))

server_hash = data["downloads"]["server"]["sha1"]

server_url = f"https://piston-data.mojang.com/v1/objects/{server_hash}/server.jar"

output_file = f"server.jar"
urllib.request.urlretrieve(server_url, output_file)

print(f"Downloaded to {output_file} at {target_version}")
