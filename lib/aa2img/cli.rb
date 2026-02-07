# frozen_string_literal: true

require "thor"

module Aa2Img
  class CLI < Thor
    desc "convert INPUT_FILE OUTPUT_FILE", "Convert AA text file to image"
    option :theme, type: :string, default: "default", desc: "Theme name"
    option :scale, type: :numeric, default: 2, desc: "PNG scale factor"
    def convert(input_file, output_file)
      text = if input_file == "-"
               $stdin.read
             else
               File.read(input_file)
             end
      Aa2Img.convert_to_file(text, output_file,
                             theme: options[:theme],
                             scale: options[:scale])
      puts "✓ #{output_file} generated"
    end

    desc "themes", "List available themes"
    def themes
      Theme.available.each { |t| puts "  - #{t}" }
    end

    desc "preview INPUT_FILE", "Parse AA and display AST (debug)"
    option :format, type: :string, default: "tree", desc: "Output format (tree / json)"
    def preview(input_file)
      text = File.read(input_file)
      grid = Grid.new(text)
      parser = Aa2Img::Parser::Orchestrator.new(grid)
      scene = parser.parse
      puts scene.to_tree_string
    end

    desc "version", "Show version"
    def version
      puts "aa2img #{Aa2Img::VERSION}"
    end
  end
end
