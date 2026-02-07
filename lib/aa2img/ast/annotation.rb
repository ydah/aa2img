# frozen_string_literal: true

module Aa2Img
  module AST
    class Annotation < BaseElement
      attr_accessor :text, :row, :arrow_col
    end
  end
end
