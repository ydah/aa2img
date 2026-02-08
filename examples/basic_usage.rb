#!/usr/bin/env ruby
# frozen_string_literal: true

require "aa2img"

aa_text = <<~'AA'
┌─────────────────────────────────────┐
│            REPL (UI)                │  ← ユーザーとの対話
├─────────────────────────────────────┤
│         Command Parser              │  ← コマンド解析
├─────────────────────────────────────┤
│           Database                  │  ← コア機能
│  ┌─────────────────────────────┐    │
│  │       StringHashMap         │    │  ← データ保存
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
AA

svg = AA2img.convert(aa_text, format: :svg, valign: :center, theme: :modern)
File.write("output.svg", svg)
puts "Generated output.svg"
