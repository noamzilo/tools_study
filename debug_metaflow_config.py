import os
from pathlib import Path

print("\n🔍 Checking Metaflow environment...")

# Force the profile and config path (this is what Metaflow expects)
os.environ["METAFLOW_PROFILE"] = "aws"
os.environ["METAFLOW_CONFIG"] = str(Path.home() / ".metaflowconfig" / "config.json")

print("METAFLOW_PROFILE =", os.environ.get("METAFLOW_PROFILE"))
print("METAFLOW_CONFIG  =", os.environ.get("METAFLOW_CONFIG"))

# Try to load the config manually
try:
    from metaflow.metaflow_config_funcs import load_config
    config = load_config()
    print("\n✅ Metaflow config loaded successfully:")
    print(config)
except Exception as e:
    print("\n❌ Failed to load Metaflow config:")
    print(type(e).__name__ + ":", e)
