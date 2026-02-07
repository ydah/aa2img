# frozen_string_literal: true

module AA2img
  module AST
    class Annotation < BaseElement
      attr_accessor :text, :row, :arrow_col
    end
  end
end
