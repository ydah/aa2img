#!/usr/bin/env ruby
# frozen_string_literal: true

require "aa2img"

aa_text = <<~'AA'
┌─────────────────────────────────────┐
│            REPL (UI)                │
├─────────────────────────────────────┤
│         Command Parser              │
├─────────────────────────────────────┤
│           Database                  │
│  ┌─────────────────────────────┐    │
│  │       StringHashMap         │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
AA

svg = AA2img.convert(aa_text, format: :svg, valign: :center, theme: :modern)
File.write("output.svg", svg)
puts "Generated output.svg"
