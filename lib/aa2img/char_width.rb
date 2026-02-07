# frozen_string_literal: true

require "unicode/display_width"

module Aa2Img
  module CharWidth
    def self.width(char)
      Unicode::DisplayWidth.of(char)
    end

    def self.wide?(char)
      width(char) > 1
    end
  end
end
