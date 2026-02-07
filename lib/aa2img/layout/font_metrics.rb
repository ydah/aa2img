# frozen_string_literal: true

module Aa2Img
  module Layout
    class FontMetrics
      attr_reader :font_size, :line_height_ratio

      def initialize(font_size: 14, line_height_ratio: 1.4)
        @font_size = font_size
        @line_height_ratio = line_height_ratio
      end

      def line_height
        font_size * line_height_ratio
      end

      def text_y_offset
        font_size * 0.35
      end
    end
  end
end
