#!/usr/bin/env bash
# install.sh — Installs drumkit.py dependencies on Lubuntu/Ubuntu
set -e

VENV_DIR="$(cd "$(dirname "$0")" && pwd)/.venv"

echo "=== drumkit.py installer ==="
echo

# ── System packages ────────────────────────────────────────────────────────
echo "[1/3] Installing system libraries…"
sudo apt-get update -qq
sudo apt-get install -y \
    python3 python3-pip python3-venv \
    pkg-config \
    libasound2-dev \
    libjack-dev \
    libportaudio2 libportaudiocpp0 portaudio19-dev \
    python3-dev

# ── Virtual environment ────────────────────────────────────────────────────
echo
echo "[2/3] Creating virtual environment at $VENV_DIR …"
python3 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"

echo "      Installing Python packages…"
pip install --upgrade pip -q
pip install \
    python-rtmidi \
    sounddevice \
    soundfile \
    numpy

read -p "      Install scipy (optional, for sample-rate conversion)? [y/N] " ans
if [[ "$ans" =~ ^[Yy]$ ]]; then
    pip install scipy
fi

deactivate

# ── Launcher script ────────────────────────────────────────────────────────
echo
echo "[3/3] Creating launcher…"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cat > "$SCRIPT_DIR/drumkit" << EOF
#!/usr/bin/env bash
# Auto-generated launcher — activates the venv and runs drumkit.py
source "$VENV_DIR/bin/activate"
exec python3 "$SCRIPT_DIR/drumkit.py" "\$@"
EOF
chmod +x "$SCRIPT_DIR/drumkit"

echo
echo "✓ Done!  Run the kit with:"
echo
echo "  ./drumkit                               # list MIDI controllers"
echo "  ./drumkit path/to/kit.xml              # run the kit"
echo "  ./drumkit path/to/kit.xml --remap      # re-do MIDI mapping"
echo
echo "Controls while playing:  [+] vol up   [-] vol down   [q] quit"
