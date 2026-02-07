# frozen_string_literal: true

module AA2img
  module Parser
    class CornerDetector
      def detect(grid)
        corners = []

        (0...grid.height).each do |row|
          (0...grid.width).each do |col|
            ch = grid.at(row, col)
            next if ch.nil? || ch == :wide_placeholder

            if ch == "+"
              type = classify_plus(grid, row, col)
              corners << { row: row, col: col, type: type } unless type == :unknown
            elsif CharClassifier.corner?(ch)
              type = CharClassifier.corner_type(ch)
              corners << { row: row, col: col, type: type } if type
            elsif CharClassifier.t_junction?(ch)
              type = CharClassifier.t_junction_type(ch)
              corners << { row: row, col: col, type: type } if type
            end
          end
        end

        corners
      end

      private

      def classify_plus(grid, row, col)
        right = grid.at(row, col + 1)
        below = grid.at(row + 1, col)
        left = grid.at(row, col - 1)
        above = grid.at(row - 1, col)

        has_right = connectable_horizontal?(right)
        has_below = connectable_vertical?(below)
        has_left = connectable_horizontal?(left)
        has_above = connectable_vertical?(above)

        case [has_right, has_below, has_left, has_above]
        when [true, true, false, false] then :top_left
        when [false, true, true, false] then :top_right
        when [true, false, false, true] then :bottom_left
        when [false, false, true, true] then :bottom_right
        when [true, true, true, false] then :top
        when [true, true, false, true] then :left
        when [false, true, true, true] then :right
        when [true, false, true, true] then :bottom
        when [true, true, true, true] then :cross
        else :unknown
        end
      end

      def connectable_horizontal?(ch)
        return false if ch.nil?

        CharClassifier.horizontal?(ch) || ch == "+" || CharClassifier.corner?(ch) || CharClassifier.t_junction?(ch)
      end

      def connectable_vertical?(ch)
        return false if ch.nil?

        CharClassifier.vertical?(ch) || ch == "+" || CharClassifier.corner?(ch) || CharClassifier.t_junction?(ch)
      end
    end
  end
end
