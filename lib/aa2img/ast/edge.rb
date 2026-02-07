# frozen_string_literal: true

module AA2img
  module AST
    class Edge < BaseElement
      attr_accessor :from, :to, :style, :arrow

      def initialize(**attrs)
        @style = :solid
        @arrow = :none
        super
      end
    end
  end
end
