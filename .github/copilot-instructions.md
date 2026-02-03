# x11minigui - AI Coding Agent Instructions

## Project Overview
This project builds a Docker container for running **MiniGUI 5.0** (a lightweight GUI framework) with X11 display support. Primary use case: Development and testing of MiniGUI applications in a containerized Ubuntu 18.04 environment on Windows 11 + WSL2.

## Architecture & Components

### Core Build Process (Dockerfile)
- **Base**: Ubuntu 18.04 with Tsinghua mirror sources (lines 6-10) for faster package downloads in China
- **MiniGUI Build**: Clones and builds MiniGUI 5.0 from FMSoft's GitLab (lines 23-27)
  - Uses `build-minigui-5.0` build scripts: `fetch-all.sh` ¡ú `build-deps.sh` ¡ú `build-minigui.sh ths`
  - Note: `mg-tests` are commented out in build (line 25)
- **Custom cURL**: Installs cURL 7.67.0 from source (lines 30-34) instead of apt package
- **SSH Access**: Configured for remote debugging via SSH (lines 37-47)

### Dependencies
- **GUI Stack**: GTK2, X11 utilities, DRM, libinput
- **CJK Font Support**: Extensive Chinese font packages (Arphic, WQY Zenhei, CNS11643)
- **Dev Tools**: GCC, autotools, CMake, gdb/gdbserver, electric-fence for memory debugging
- **Graphics**: JPEG, PNG, FreeType, HarfBuzz for rendering

## Developer Workflows

### Building the Container
```bash
docker build -t x11ubuntu .
```

### Running with X11 Display (Windows + WSL2)
```bash
docker run -ti --net=host --rm -e DISPLAY=host.docker.internal:0 -v /tmp/.X11-unix:/tmp/.X11-unix x11ubuntu --gpus
```
- **Critical**: `DISPLAY=host.docker.internal:0` routes X11 to Windows host
- Requires X server running on Windows (e.g., VcXsrv, Xming)
- `--net=host`: Container shares host network for X11 communication

### Remote Debugging
- SSH enabled on port 22 with root access
- Root password: `1-q2-w3-e4-r5-t` (line 39)
- GDB/gdbserver pre-installed for debugging MiniGUI applications

## Project-Specific Conventions

### Chinese Localization Focus
- Mirror sources use Tsinghua University repos for China network optimization
- Comprehensive CJK font installation indicates target users in Chinese markets
- README is in Chinese

### Known Limitations (from README)
- Firefox branch can open Baidu with Chinese characters displayed correctly
- **No input method support** currently available in the container

### File Structure
- Single-stage Dockerfile (no multi-stage build)
- No source code in repo - relies entirely on external MiniGUI builds
- `.gitignore` uses Visual Studio template (legacy artifact)

## When Making Changes

### Dockerfile Modifications
- Keep Tsinghua mirror sources unless changing base image
- Preserve CJK font packages for Chinese text support
- SSH configuration is intentional for debugging - don't remove unless requested
- The `./build-minigui.sh ths` parameter (line 26) is significant - verify meaning before changing

### Testing Changes
- Always test X11 display forwarding after Dockerfile changes
- Verify Chinese font rendering if modifying font packages
- Check MiniGUI samples/demos work: `/usr/local/bin/mg*` binaries

### Adding Features
- For input method support: investigate fcitx or ibus packages
- Keep image size manageable - cleanup layers after apt installs (line 22 pattern)
- Use `apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*` after package installs
