# frozen_string_literal: true

module AA2img
  module Parser
    class SectionDetector
      def detect(grid, box)
        dividers = []

        (box.top + 1...box.bottom).each do |row|
          left_ch = grid.at(row, box.left)
          right_ch = grid.at(row, box.right)

          next unless t_left?(left_ch) || left_ch == "+"
          next unless t_right?(right_ch) || right_ch == "+"

          all_horizontal = (box.left + 1...box.right).all? do |col|
            ch = grid.at(row, col)
            CharClassifier.horizontal?(ch) || CharClassifier.t_junction?(ch)
          end

          dividers << row if all_horizontal
        end

        build_sections(box, dividers)
      end

      private

      def t_left?(ch)
        CharClassifier::T_JUNCTIONS[:left].include?(ch)
      end

      def t_right?(ch)
        CharClassifier::T_JUNCTIONS[:right].include?(ch)
      end

      def build_sections(box, dividers)
        boundaries = [box.top] + dividers + [box.bottom]
        boundaries.each_cons(2).map do |top_row, bottom_row|
          AST::Section.new(top: top_row, bottom: bottom_row)
        end
      end
    end
  end
end
