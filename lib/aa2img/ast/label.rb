# frozen_string_literal: true

module AA2img
  module AST
    class Label < BaseElement
      attr_accessor :text, :row, :col, :align

      def initialize(**attrs)
        @align = :center
        super
      end
    end
  end
end
