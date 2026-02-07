# frozen_string_literal: true

module Aa2Img
  module Parser
    class ArrowDetector
      ARROW_PATTERNS = [
        { pattern: /->/, style: :solid, arrow: :forward },
        { pattern: /-->/, style: :dashed, arrow: :forward },
        { pattern: /=>/, style: :solid, arrow: :forward },
        { pattern: /<-/, style: :solid, arrow: :backward },
        { pattern: /<--/, style: :dashed, arrow: :backward },
        { pattern: /<->/, style: :solid, arrow: :both },
        { pattern: /<-->/, style: :dashed, arrow: :both }
      ].freeze

      def detect(grid)
        edges = []
        edges.concat(detect_horizontal_arrows(grid))
        edges.concat(detect_vertical_arrows(grid))
        edges
      end

      private

      def detect_horizontal_arrows(grid)
        edges = []
        (0...grid.height).each do |row|
          col = 0
          while col < grid.width
            ch = grid.at(row, col)
            if ch == "-" || ch == "=" || ch == "<"
              edge = try_horizontal_arrow(grid, row, col)
              if edge
                edges << edge
                col = edge.to[:col] + 1
                next
              end
            end
            col += 1
          end
        end
        edges
      end

      def try_horizontal_arrow(grid, row, start_col)
        col = start_col
        chars = []

        while col < grid.width
          ch = grid.at(row, col)
          break unless ch == "-" || ch == "=" || ch == ">" || ch == "<"

          chars << ch
          break if ch == ">" && col > start_col

          col += 1
        end

        text = chars.join
        return nil if text.length < 2

        style = text.include?("--") ? :dashed : :solid
        arrow = if text.start_with?("<") && text.end_with?(">")
                  :both
                elsif text.end_with?(">")
                  :forward
                elsif text.start_with?("<")
                  :backward
                else
                  return nil
                end

        AST::Edge.new(
          from: { row: row, col: start_col },
          to: { row: row, col: start_col + chars.length - 1 },
          style: style,
          arrow: arrow
        )
      end

      def detect_vertical_arrows(grid)
        edges = []
        (0...grid.width).each do |col|
          row = 0
          while row < grid.height
            ch = grid.at(row, col)
            if ch == "|" || ch == "^" || ch == "v"
              edge = try_vertical_arrow(grid, row, col)
              if edge
                edges << edge
                row = edge.to[:row] + 1
                next
              end
            end
            row += 1
          end
        end
        edges
      end

      def try_vertical_arrow(grid, start_row, col)
        row = start_row
        chars = []

        while row < grid.height
          ch = grid.at(row, col)
          break unless ch == "|" || ch == "^" || ch == "v"

          chars << ch
          break if ch == "v" && row > start_row

          row += 1
        end

        return nil if chars.length < 2

        arrow = if chars.first == "^" && chars.last == "v"
                  :both
                elsif chars.last == "v"
                  :forward
                elsif chars.first == "^"
                  :backward
                else
                  return nil
                end

        AST::Edge.new(
          from: { row: start_row, col: col },
          to: { row: start_row + chars.length - 1, col: col },
          style: :solid,
          arrow: arrow
        )
      end
    end
  end
end
