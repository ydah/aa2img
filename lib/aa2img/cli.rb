# frozen_string_literal: true

require "thor"

module AA2img
  class CLI < Thor
    desc "convert INPUT_FILE OUTPUT_FILE", "Convert AA text file to image"
    option :theme, type: :string, default: "default", desc: "Theme name or YAML path"
    option :scale, type: :numeric, default: 2, desc: "PNG scale factor"
    option :valign, type: :string, default: "top", desc: "Vertical text alignment (top / center / bottom)"
    def convert(input_file, output_file)
      text = if input_file == "-"
               $stdin.read
             else
               File.read(input_file)
             end
      AA2img.convert_to_file(text, output_file,
                             theme: options[:theme],
                             scale: options[:scale],
                             valign: options[:valign].to_sym)
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
      parser = AA2img::Parser::Orchestrator.new(grid)
      scene = parser.parse
      puts scene.to_tree_string
    end

    desc "version", "Show version"
    def version
      puts "aa2img #{AA2img::VERSION}"
    end
  end
end
