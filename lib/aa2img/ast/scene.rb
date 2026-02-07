# frozen_string_literal: true

module AA2img
  module AST
    class Scene
      attr_accessor :elements, :width, :height

      def initialize
        @elements = []
        @width = 0
        @height = 0
      end

      def boxes
        elements.select { |e| e.is_a?(Box) }
      end

      def edges
        elements.select { |e| e.is_a?(Edge) }
      end

      def all_boxes
        result = []
        boxes.each do |box|
          result << box
          result.concat(collect_nested_boxes(box))
        end
        result
      end

      def to_tree_string(indent = 0)
        lines = []
        prefix = "  " * indent
        lines << "#{prefix}Scene (width: #{width}, height: #{height})"
        elements.each do |el|
          lines << element_to_tree(el, indent + 1)
        end
        lines.join("\n")
      end

      private

      def collect_nested_boxes(box)
        result = []
        (box.children || []).each do |child|
          result << child
          result.concat(collect_nested_boxes(child))
        end
        result
      end

      def element_to_tree(el, indent)
        prefix = "  " * indent
        case el
        when Box
          box_to_tree(el, indent)
        when Edge
          "#{prefix}Edge #{el.from} -> #{el.to} (#{el.style}, #{el.arrow})"
        else
          "#{prefix}#{el.class.name}"
        end
      end

      def box_to_tree(box, indent)
        prefix = "  " * indent
        lines = ["#{prefix}└── Box (#{box.top},#{box.left})-(#{box.bottom},#{box.right})"]
        (box.sections || []).each_with_index do |section, i|
          section_labels = (section.labels || []).map(&:text).join(", ")
          ann_text = section.annotation ? " + annotation \"#{section.annotation.text}\"" : ""
          lines << "#{prefix}    ├── Section[#{i}] (row #{section.top}..#{section.bottom}): \"#{section_labels}\"#{ann_text}"
        end
        (box.children || []).each do |child|
          lines << box_to_tree(child, indent + 2)
        end
        lines.join("\n")
      end
    end
  end
end
