# frozen_string_literal: true

module AA2img
  module Parser
    class TextExtractor
      ANNOTATION_PATTERN = /←\s*(.+)$/

      def extract_labels(grid, section, box, children: [])
        labels = []
        (section.top + 1...section.bottom).each do |row|
          next if row_inside_child?(row, children)

          text = extract_row_text(grid, row, box.left + 1, box.right - 1)
          stripped = text.strip
          next if stripped.empty?
          next if all_structural?(stripped)

          cleaned = clean_nested_structural(stripped)
          next if cleaned.empty?

          labels << AST::Label.new(
            text: cleaned,
            row: row,
            col: calculate_center(box),
            align: :center
          )
        end
        labels
      end

      def extract_annotations(grid, box)
        annotations = []
        (box.top..box.bottom).each do |row|
          right_text = extract_row_text(grid, row, box.right + 1, grid.width - 1)
          if (match = right_text.match(ANNOTATION_PATTERN))
            annotations << AST::Annotation.new(
              text: match[1].strip,
              row: row,
              arrow_col: box.right + 1
            )
          end
        end
        annotations
      end

      private

      def extract_row_text(grid, row, col_start, col_end)
        return "" if col_start > col_end

        (col_start..col_end).map { |col|
          ch = grid.at(row, col)
          if ch.nil? || ch == :wide_placeholder
            ""
          else
            ch.to_s
          end
        }.join
      end

      def calculate_center(box)
        (box.left + box.right) / 2
      end

      def all_structural?(text)
        text.each_char.all? { |ch| CharClassifier.structural?(ch) }
      end

      def clean_nested_structural(text)
        text.gsub(/[┌┐└┘├┤┬┴┼─│━═╔╗╚╝╠╣╦╩╬║┏┓┗┛┣┫┳┻╋┃+\-|]/, " ").strip
      end

      def row_inside_child?(row, children)
        children.any? { |child| row >= child.top && row <= child.bottom }
      end
    end
  end
end
