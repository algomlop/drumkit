# Easy drumkit

Low-latency MIDI drum sampler for **DrumGizmo** kits.

## Why this project?
This program was born out of frustration with existing Linux alternatives like the official **DrumGizmo** plugin or **Hydrogen**, which were found to be overly complex for a simple "plug and play" setup. This script provides a lightweight, high-performance bridge between your MIDI controller and DrumGizmo XML kits without needing a DAW.

### Tested Environment
* **OS:** Lubuntu (Linux) and Windows 10.
* **Kit:** Specifically tested with the **CrocellKit** (DrumGizmo format). In releases you have a 5 lane working drumkit example.

---

## Installation

The installer handles system dependencies (`libasound2-dev`, `libportaudio2`, `pkg-config`, etc.), creates a Python virtual environment, and generates a launcher.

```bash
bash install.sh
```

## Quick Start


* List MIDI controllers: Run without arguments to see available devices.

```bash
./drumkit
```


* Run the kit: Provide the path to the XML kit file.

```bash
./drumkit CrocellKit_default.xml
```

* First Run: MIDI Mapping
  
On the first run with a specific kit, the program will walk you through each instrument.
Hit the corresponding pad on your controller to map it.
Press Enter to skip any instrument.
Mappings are saved in ~/.config/drumkit/ and loaded automatically thereafter.

## Arguments


```bash
./drumkit [kit.xml] [options]
```

| Option  | Effect | Default |
| ------------- | ------------- | ------------- |
| --remap  | Discard saved mapping and re-map from scratch.  | -  |
| --blocksize N  | Audio block size (lower = less latency).  | 128 |
| --volume N | Start at specific volume (e.g., 1.5 for 150%).| 1.0 |
| --channel N | Listen to a specific MIDI channel (1-16). | All (no filter) |
| --velocity-volume on/off | Use MIDI velocity to further scale sample volume. | off |
| --velocity-calibrate on/off | Dynamically learn min/max velocity for your pads. | on |

## Controls while playing

* \+ / - : Increase/decrease volume (no upper limit).
* d : Toggle Debug Mode to see raw MIDI input (hex/dec) in real-time.
* q : Quit the program.

## How it works

* Pre-loaded RAM: All WAV samples are loaded as float32 numpy arrays; there is zero disk I/O during playback.
* Low Latency: Uses a sounddevice output callback in a native thread that bypasses the Python GIL.
* MIDI Sharing: Uses ALSA Sequencer in subscription mode. Other programs (like aseqdump or a DAW) can read the same MIDI port simultaneously.
* Velocity Layers & Round-Robin: Automatically selects the best velocity layer and rotates between samples of the same power to avoid the "machine-gun" effect.
* Dynamic Calibration: When active, it learns the physical range of your pads to ensure you can trigger the full spectrum of samples (softest to hardest) regardless of your controller's sensitivity.


## Troubleshooting

* No MIDI devices found: Check if ALSA sees your device with aconnect -i or ensure the sequencer module is loaded via sudo modprobe snd-seq.
* High latency / xruns: Try lowering the block size (--blocksize 64). For better performance, install realtime-privileges and add your user to the audio group.

```bash
sudo apt install realtime-privileges
sudo adduser $USER audio
```
(Note: You must log out and back in for group changes to take effect).
