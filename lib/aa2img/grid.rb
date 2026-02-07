# frozen_string_literal: true

require "unicode/display_width"

module AA2img
  class Grid
    attr_reader :rows, :width, :height

    def initialize(text)
      lines = text.lines.map(&:chomp)
      @height = lines.size
      @rows = lines.map { |line| normalize_line(line) }
      @width = @rows.map(&:size).max || 0
      @rows.each { |row| row.fill(" ", row.size...@width) }
    end

    def at(row, col)
      return nil if row < 0 || row >= @height || col < 0 || col >= @width

      @rows[row][col]
    end

    private

    def normalize_line(line)
      cells = []
      line.each_char do |ch|
        w = Unicode::DisplayWidth.of(ch)
        cells << ch
        (w - 1).times { cells << :wide_placeholder }
      end
      cells
    end
  end
end
