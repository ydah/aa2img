# frozen_string_literal: true

module AA2img
  module Parser
    class NestingAnalyzer
      def analyze(boxes)
        sorted = boxes.sort_by { |b| -b.area }

        sorted.each do |child|
          parent = sorted.find do |candidate|
            candidate != child && candidate.contains?(child)
          end
          parent&.add_child(child)
        end

        sorted.reject { |b| sorted.any? { |other| other != b && other.contains?(b) } }
      end
    end
  end
end
