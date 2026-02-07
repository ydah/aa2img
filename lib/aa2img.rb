# frozen_string_literal: true

require_relative "aa2img/version"
require_relative "aa2img/char_width"
require_relative "aa2img/grid"

require_relative "aa2img/ast/base_element"
require_relative "aa2img/ast/box"
require_relative "aa2img/ast/section"
require_relative "aa2img/ast/label"
require_relative "aa2img/ast/annotation"
require_relative "aa2img/ast/edge"
require_relative "aa2img/ast/scene"

require_relative "aa2img/parser/char_classifier"
require_relative "aa2img/parser/corner_detector"
require_relative "aa2img/parser/edge_tracer"
require_relative "aa2img/parser/box_builder"
require_relative "aa2img/parser/section_detector"
require_relative "aa2img/parser/nesting_analyzer"
require_relative "aa2img/parser/text_extractor"
require_relative "aa2img/parser/arrow_detector"
require_relative "aa2img/parser"

require_relative "aa2img/layout/grid_metrics"
require_relative "aa2img/layout/font_metrics"
require_relative "aa2img/layout/calculator"

require_relative "aa2img/renderer/base"
require_relative "aa2img/renderer/svg_renderer"
require_relative "aa2img/renderer/png_renderer"

require_relative "aa2img/theme"
require_relative "aa2img/cli"

module Aa2Img
  class Error < StandardError; end

  class << self
    def convert(input, format: :svg, theme: "default", scale: 2)
      grid = Grid.new(input)
      parser = Parser::Orchestrator.new(grid)
      scene = parser.parse
      loaded_theme = Theme.load(theme)

      renderer = case format
                 when :svg then Renderer::SVGRenderer.new
                 when :png then Renderer::PNGRenderer.new
                 else raise ArgumentError, "Unsupported format: #{format}"
                 end

      options = { theme: loaded_theme }
      options[:scale] = scale if format == :png

      renderer.render(scene, **options)
    end

    def convert_to_file(input, output_path, **options)
      format = File.extname(output_path).delete(".").to_sym
      result = convert(input, format: format, **options)
      File.binwrite(output_path, result)
      output_path
    end
  end
end
