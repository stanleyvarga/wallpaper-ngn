# wallpaper-ngn
****
This utility does a thing. That thing is changing your wallpaper. It can even do it without you asking, because it's just that helpful. Or maybe it's passive-aggressive. You decide. It's a command-line tool, so naturally, it's very serious business.
****
![big brain](./big_brain.gif)

## Installation

1. Install the required `wallpaper` package:
   ```bash
   brew install wallpaper
   ```

2. Clone this repository:
   ```bash
   git clone [repo-url]
   cd wallpaper-ngn
   ```

3. Make the script executable (if not already):
   ```bash
   chmod +x wallpaper-ngn
   ```

4. Create a symbolic link to make the command available globally (optional):
   ```bash
   sudo ln -s "$(pwd)/wallpaper-ngn" /usr/local/bin/
   ```

## Directory Structure

The script expects wallpapers to be organized in the following directory structure:
```
~/Wallpapers/
├── dawn/
├── dusk/
├── morning/
├── night/
├── noon/
├── sunrise/
├── sunset/
└── unused/ (not used in the wallpaper engine)
```

Make sure to create this directory structure and place your wallpaper images in the appropriate folders.

## Usage

```bash
wallpaper-ngn [OPTIONS]
```

### Options:

- `--random`: Set a random wallpaper
- `--screens <value>`: Specify which screens to set (all, 1, 2, etc.)
- `--help`: Show help message

### Examples:

Set a random wallpaper on all screens:
```bash
wallpaper-ngn --random --screens all
```

Set a random wallpaper on a specific screen:
```bash
wallpaper-ngn --random --screens 1
```

## Future Features

- Set wallpapers based on time of day
- Filter wallpapers by category
- Add/remove wallpapers to/from categories
- Create wallpaper playlists/rotations

## License

MIT 
