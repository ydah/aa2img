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

      def label_position(label, box, section: nil, valign: :top, label_index: 0, label_count: 1, children: [])
        rect = box_rect(box)
        x = rect[:x] + rect[:width] / 2

        if section
          section_top_y = to_px(section.top, 0)[:y]
          section_bottom_y = to_px(section.bottom, 0)[:y]
          available_top_y, available_bottom_y = available_region(
            section_top_y, section_bottom_y, section, children
          )
          total_text_height = label_count * @metrics.cell_height
          inner_padding = @metrics.cell_height * 0.2
          available_height = available_bottom_y - available_top_y

          case valign
          when :top
            y = available_top_y + inner_padding + (label_index + 0.5) * @metrics.cell_height
          when :bottom
            y = available_bottom_y - inner_padding - (label_count - label_index - 0.5) * @metrics.cell_height
          else
            offset = (available_height - total_text_height) / 2.0
            y = available_top_y + offset + (label_index + 0.5) * @metrics.cell_height
          end
        else
          y = to_px(label.row, 0)[:y] + @metrics.cell_height * 0.5
        end

        { x: x, y: y }
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

      private

      def available_region(section_top_y, section_bottom_y, section, children)
        section_children = children.select do |child|
          child.top >= section.top && child.bottom <= section.bottom
        end

        return [section_top_y, section_bottom_y] if section_children.empty?

        child_top_y = section_children.map { |c| to_px(c.top, 0)[:y] }.min
        child_bottom_y = section_children.map { |c| to_px(c.bottom, 0)[:y] }.max

        space_above = child_top_y - section_top_y
        space_below = section_bottom_y - child_bottom_y

        if space_above >= space_below
          [section_top_y, child_top_y]
        else
          [child_bottom_y, section_bottom_y]
        end
      end
    end
  end
end
