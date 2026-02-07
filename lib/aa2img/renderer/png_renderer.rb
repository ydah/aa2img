# frozen_string_literal: true

require "tempfile"

module Aa2Img
  module Renderer
    class PNGRenderer < Base
      def render(scene, theme:, scale: 2, **_options)
        require "mini_magick"

        svg_xml = SVGRenderer.new.render(scene, theme: theme)

        Tempfile.create(["aa2img", ".svg"]) do |svg_file|
          svg_file.write(svg_xml)
          svg_file.flush

          image = MiniMagick::Image.open(svg_file.path)
          image.density(72 * scale)
          image.format("png")
          image.to_blob
        end
      end
    end
  end
end
