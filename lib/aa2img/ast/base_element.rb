# frozen_string_literal: true

module AA2img
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
