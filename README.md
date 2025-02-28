# Big brains command line wallpaper ngn

This utility does a thing. That thing is changing your wallpaper. It can even do it without you asking, because it's just that helpful. Or maybe it's passive-aggressive. You decide. It's a command-line tool, so naturally, it's very serious business.

Oh and it only works on macos. Probably. 

![big brain](./big_brain.gif)

>The Bureaucratic Intergalactic Wallpaper Service, in accordance with Directive 742-Omega, Sub-Section Theta-9, defines this application as follows: Official wallpaper management tool for Earth-sized planets within habitable zones. (As determined by the Galactic Standard Habitable Zone Committee, Subsection 42, Paragraph 7b, Clause 3, Appendix Gamma-7.) Seasonal changes are calibrated to the planet's unique rotational wobble and the local space slug migration patterns. Please file Form 789-B if your wallpaper does not reflect the correct 'cosmic ambiance.'"

## Directory Structure

The script uses the following directory structure for wallpapers:

```
~/Wallpapers/
├── dawn/
├── sunrise/
├── morning/
├── afternoon/
├── sunset/
├── dusk/
├── night/
└── unused/  # Images in this folder are ignored
```

## Usage

```
wp-ngn [OPTIONS]
```

### Options

| Option | Description |
|--------|-------------|
| `--random` | Set a random wallpaper from the entire collection |
| `--dynamic` | Set a wallpaper based on the current time of day |
| `--override` | Force wallpaper change even if current period wallpaper is already set |
| `--screens <value>` | Specify which screens to set (all, 1, 2, etc., or custom names) |
| `--list-screens` | List all available screens |
| `--name-screen <id> <name>` | Set a custom name for a specific screen |
| `--help` | Show help message |

## Examples

### Set a random wallpaper on all screens
```
wp-ngn --random
```

### Set a time-appropriate wallpaper
```
wp-ngn --dynamic
```

### Set a random wallpaper on a specific screen
```
wp-ngn --random --screens 1
```

### Set a dynamic wallpaper on a named screen
```
wp-ngn --dynamic --screens acer
```

### Name a screen for easier reference
```
wp-ngn --name-screen 1 macbook
```

### List available screens
```
wp-ngn --list-screens
```

## Time Periods

The script defines the following time periods, which vary by month to account for seasonal changes in daylight:

- **Dawn**: Early morning before sunrise
- **Sunrise**: Period during sunrise
- **Morning**: Morning hours
- **Afternoon**: Afternoon hours
- **Sunset**: Period during sunset
- **Dusk**: Evening after sunset
- **Night**: Nighttime hours

Each month has its own specific time range definitions for these periods to match seasonal daylight patterns.

## License
MIT 
