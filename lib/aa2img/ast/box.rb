# frozen_string_literal: true

module AA2img
  module AST
    class Box < BaseElement
      attr_accessor :top, :left, :bottom, :right
      attr_accessor :sections, :children, :labels, :annotations

      def initialize(**attrs)
        @sections = []
        @children = []
        @labels = []
        @annotations = []
        super
      end

      def area
        (bottom - top) * (right - left)
      end

      def contains?(other)
        top < other.top && bottom > other.bottom &&
          left < other.left && right > other.right
      end

      def add_child(child)
        @children << child
      end

      def all_labels
        own = labels || []
        from_sections = (sections || []).flat_map { |s| s.labels || [] }
        own + from_sections
      end

      def all_annotations
        own = annotations || []
        from_sections = (sections || []).flat_map { |s| s.annotation ? [s.annotation] : [] }
        (own + from_sections).uniq { |ann| [ann.row, ann.arrow_col, ann.text] }
      end
    end
  end
end
