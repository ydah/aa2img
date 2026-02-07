# frozen_string_literal: true

module Aa2Img
  module Layout
    class Calculator
      def initialize(scene, theme)
        @scene = scene
        @metrics = GridMetrics.new(theme.metrics)
      end

      def to_px(row, col)
        x = col * @metrics.cell_width + @metrics.padding
        y = row * @metrics.cell_height + @metrics.padding
        { x: x, y: y }
      end

      def box_rect(box)
        top_left = to_px(box.top, box.left)
        bottom_right = to_px(box.bottom, box.right)
        {
          x: top_left[:x],
          y: top_left[:y],
          width: bottom_right[:x] - top_left[:x],
          height: bottom_right[:y] - top_left[:y]
        }
      end

      def label_position(label, box)
        rect = box_rect(box)
        {
          x: rect[:x] + rect[:width] / 2,
          y: to_px(label.row, 0)[:y] + @metrics.cell_height * 0.7
        }
      end

      def annotation_position(annotation, box)
        rect = box_rect(box)
        {
          x: rect[:x] + rect[:width] + 15,
          y: to_px(annotation.row, 0)[:y] + @metrics.cell_height * 0.7
        }
      end

      def total_width
        @scene.width * @metrics.cell_width + @metrics.padding * 2
      end

      def total_height
        @scene.height * @metrics.cell_height + @metrics.padding * 2
      end
    end
  end
end
