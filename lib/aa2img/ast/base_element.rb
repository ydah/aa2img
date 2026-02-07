# frozen_string_literal: true

module Aa2Img
  module AST
    class BaseElement
      def initialize(**attrs)
        attrs.each do |key, value|
          send(:"#{key}=", value)
        end
      end
    end
  end
end
