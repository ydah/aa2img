# frozen_string_literal: true

module Aa2Img
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
