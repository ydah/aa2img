# frozen_string_literal: true

module AA2img
  module AST
    class Section < BaseElement
      attr_accessor :top, :bottom
      attr_accessor :labels, :annotation

      def initialize(**attrs)
        @labels = []
        @annotation = nil
        super
      end
    end
  end
end
