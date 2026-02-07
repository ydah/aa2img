<h1 align="center">aa2img</h1>
<p align="center">
  <strong>Convert ASCII/Unicode diagrams into clean SVG and PNG images</strong>
</p>
<p align="center">
  <img src="https://img.shields.io/badge/ruby-%3E%3D%203.2-red.svg" alt="Ruby 3.2+">
  <img src="https://img.shields.io/badge/output-SVG%20%2F%20PNG-2f855a.svg" alt="Output SVG/PNG">
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License MIT">
  <a href="https://github.com/ydah/aa2img/actions/workflows/main.yml">
    <img src="https://github.com/ydah/aa2img/actions/workflows/main.yml/badge.svg" alt="CI">
  </a>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#diagram-syntax">Diagram Syntax</a> •
  <a href="#themes">Themes</a>
</p>

---

`aa2img` parses text-based box diagrams and renders them as themed images.
It is useful for docs, README files, and architecture notes where you want to keep diagrams editable as plain text.

## Features

- Parses both Unicode and ASCII box-drawing styles (`┌─┐ │ └─┘` and `+--+ |  | +--+`)
- Detects section separators (`├──┤`) inside boxes
- Detects nested parent-child box structures
- Renders right-side annotations in `← note` format
- Handles full-width characters, including Japanese labels
- Supports `SVG` and `PNG` output
- Ships with 4 built-in themes: `default`, `blueprint`, `monochrome`, `modern`
- Supports vertical label alignment: `top`, `center`, `bottom`

## Installation

### Requirements

- Ruby `3.2+`
- ImageMagick (required only for PNG output)

```bash
# macOS
brew install imagemagick

# Ubuntu / Debian
sudo apt install imagemagick
```

### Add to Gemfile

```ruby
gem "aa2img", github: "ydah/aa2img"
```

After the gem is published to RubyGems, you can also install it with:

```bash
gem install aa2img
```

## Usage

### Quick Start (CLI)

1. Create a text diagram file:

```txt
┌────────────────────────────┐
│        API Gateway         │
├────────────────────────────┤
│        Application         │
│  ┌──────────────────────┐  │
│  │       Database       │  │
│  └──────────────────────┘  │
└────────────────────────────┘
```

2. Convert to SVG:

```bash
aa2img convert diagram.txt output.svg
```

3. Convert to PNG:

```bash
aa2img convert diagram.txt output.png --scale 3
```

### Commands

| Command | Description |
|---|---|
| `aa2img convert INPUT_FILE OUTPUT_FILE` | Convert text diagram to image (format inferred from extension) |
| `aa2img themes` | List available themes |
| `aa2img preview INPUT_FILE` | Show parsed AST tree for debugging |
| `aa2img version` | Show version |

### `convert` Options

| Option | Description |
|---|---|
| `--theme NAME_OR_PATH` | Built-in theme name (`default`, `blueprint`, `monochrome`, `modern`) or YAML file path |
| `--scale N` | Scale factor for PNG output (default: `2`) |
| `--valign POS` | Vertical label alignment (`top`, `center`, `bottom`) |

Notes:
- Use `-` as `INPUT_FILE` to read from stdin.
- Output format is inferred from `OUTPUT_FILE` extension (`.svg` or `.png`).

```bash
# Read from stdin
cat diagram.txt | aa2img convert - output.svg

# Use blueprint theme
aa2img convert diagram.txt blueprint.svg --theme blueprint

# Use custom theme file
aa2img convert diagram.txt custom.svg --theme ./themes/my-theme.yml

# Center label alignment
aa2img convert diagram.txt centered.svg --valign center
```

### Ruby API

```ruby
require "aa2img"

aa = <<~AA
  ┌──────┐
  │ Test │
  └──────┘
AA

# Get SVG string
svg = Aa2Img.convert(aa, format: :svg, theme: "default", valign: :center)

# Write to file (format inferred from extension)
Aa2Img.convert_to_file(aa, "diagram.png", theme: "monochrome", scale: 2, valign: :top)
```

## Diagram Syntax

### Basic Boxes

Unicode:

```txt
┌──────┐
│ API  │
└──────┘
```

ASCII:

```txt
+------+
| API  |
+------+
```

### Sectioned Boxes

```txt
┌────────────────┐
│ Presentation   │
├────────────────┤
│ Application    │
├────────────────┤
│ Infrastructure │
└────────────────┘
```

### Annotations

```txt
┌──────────┐  ← user input
│  REPL    │
└──────────┘
```

## Themes

Built-in themes:

- `default`: balanced light theme
- `blueprint`: deep-blue blueprint-like style
- `monochrome`: print-friendly grayscale style
- `modern`: clean, rounded, modern UI style

```bash
aa2img themes
```

CLI also accepts a YAML path for custom themes:

```bash
aa2img convert diagram.txt output.svg --theme ./themes/my-theme.yml
```

You can also pass a custom theme hash from Ruby:

```ruby
custom_theme = {
  "background_color" => "#ffffff",
  "box_fill" => "#f8fafc",
  "box_stroke" => "#334155",
  "text_color" => "#0f172a",
  "font_family" => "'Noto Sans JP', sans-serif"
}

svg = Aa2Img.convert(aa, format: :svg, theme: custom_theme)
```

## Notes

- Current parser behavior is optimized for box/layer diagrams.
- Annotation detection currently supports right-side `←` markers.
- `preview --format` is reserved for future expansion; current output is tree-style.

## Development

```bash
git clone https://github.com/ydah/aa2img.git
cd aa2img
bin/setup
bundle exec rspec
```

Run the example script:

```bash
bundle exec ruby examples/basic_usage.rb
```

## Contributing

Issues and pull requests are welcome at `https://github.com/ydah/aa2img`.

## License

[MIT License](LICENSE.txt)
