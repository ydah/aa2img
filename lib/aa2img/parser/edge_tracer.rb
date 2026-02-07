# frozen_string_literal: true

module Aa2Img
  module Parser
    class EdgeTracer
      def initialize(grid)
        @grid = grid
      end

      def trace(row, col, direction)
        positions = []
        r, c = row, col

        case direction
        when :right
          c += 1
          while c < @grid.width
            ch = @grid.at(r, c)
            break unless traceable_horizontal?(ch)

            positions << [r, c]
            break if stop_horizontal?(ch)

            c += 1
          end
        when :left
          c -= 1
          while c >= 0
            ch = @grid.at(r, c)
            break unless traceable_horizontal?(ch)

            positions << [r, c]
            break if stop_horizontal?(ch)

            c -= 1
          end
        when :down
          r += 1
          while r < @grid.height
            ch = @grid.at(r, c)
            break unless traceable_vertical?(ch)

            positions << [r, c]
            break if stop_vertical?(ch)

            r += 1
          end
        when :up
          r -= 1
          while r >= 0
            ch = @grid.at(r, c)
            break unless traceable_vertical?(ch)

            positions << [r, c]
            break if stop_vertical?(ch)

            r -= 1
          end
        end

        positions
      end

      def trace_connects?(from_row, from_col, to_row, to_col, direction)
        positions = trace(from_row, from_col, direction)
        positions.include?([to_row, to_col])
      end

      private

      def traceable_horizontal?(ch)
        return false if ch.nil?

        CharClassifier.horizontal?(ch) || ch == "+" ||
          CharClassifier.corner?(ch) || CharClassifier.t_junction?(ch)
      end

      def traceable_vertical?(ch)
        return false if ch.nil?

        CharClassifier.vertical?(ch) || ch == "+" ||
          CharClassifier.corner?(ch) || CharClassifier.t_junction?(ch)
      end

      def stop_horizontal?(ch)
        return false if ch.nil?

        corner_type = CharClassifier.corner_type(ch)
        return true if corner_type

        return true if ch == "+"

        tj_type = CharClassifier.t_junction_type(ch)
        return false if tj_type == :top || tj_type == :bottom || tj_type == :cross

        !tj_type.nil?
      end

      def stop_vertical?(ch)
        return false if ch.nil?

        corner_type = CharClassifier.corner_type(ch)
        return true if corner_type

        return true if ch == "+"

        tj_type = CharClassifier.t_junction_type(ch)
        return false if tj_type == :left || tj_type == :right || tj_type == :cross

        !tj_type.nil?
      end
    end
  end
end
