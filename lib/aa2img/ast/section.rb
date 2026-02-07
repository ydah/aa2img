# frozen_string_literal: true

module Aa2Img
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
