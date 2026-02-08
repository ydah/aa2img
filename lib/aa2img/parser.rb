# frozen_string_literal: true

module AA2img
  module Parser
    class Orchestrator
      def initialize(grid)
        @grid = grid
      end

      def parse
        corner_detector = CornerDetector.new
        corners = corner_detector.detect(@grid)

        box_builder = BoxBuilder.new
        boxes = box_builder.detect(@grid, corners)

        nesting_analyzer = NestingAnalyzer.new
        top_level_boxes = nesting_analyzer.analyze(boxes)

        section_detector = SectionDetector.new
        text_extractor = TextExtractor.new

        boxes.each do |box|
          sections = section_detector.detect(@grid, box)
          box.sections = sections

          sections.each do |section|
            section.labels = text_extractor.extract_labels(@grid, section, box, children: box.children)
          end

          box.annotations = text_extractor.extract_annotations(@grid, box, children: box.children)

          box.annotations.each do |ann|
            matching_section = sections.find { |s| ann.row > s.top && ann.row < s.bottom }
            matching_section&.annotation = ann
          end
        end

        scene = AST::Scene.new
        scene.width = @grid.width
        scene.height = @grid.height
        scene.elements = top_level_boxes

        scene
      end
    end
  end
end
