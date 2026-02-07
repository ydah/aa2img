# frozen_string_literal: true

module AA2img
  module Parser
    class BoxBuilder
      def detect(grid, corners)
        boxes = []
        tracer = EdgeTracer.new(grid)

        top_lefts = corners.select { |c| c[:type] == :top_left }

        top_lefts.each do |tl|
          find_matching_corners(tracer, tl, :right, corners).each do |tr|
            next unless [:top_right, :right].include?(tr[:type]) || tr[:type] == :cross

            find_matching_corners(tracer, tr, :down, corners).each do |br|
              next unless [:bottom_right, :bottom].include?(br[:type]) || br[:type] == :cross

              find_matching_corners(tracer, br, :left, corners).each do |bl|
                next unless [:bottom_left, :left].include?(bl[:type]) || bl[:type] == :cross
                next unless bl[:row] == br[:row] && bl[:col] == tl[:col]

                if tracer.trace_connects?(bl[:row], bl[:col], tl[:row], tl[:col], :up)
                  boxes << AST::Box.new(
                    top: tl[:row], left: tl[:col],
                    bottom: br[:row], right: br[:col]
                  )
                end
              end
            end
          end
        end

        remove_duplicates(boxes)
      end

      private

      def find_matching_corners(tracer, from, direction, corners)
        reachable_positions = tracer.trace(from[:row], from[:col], direction)
        corners.select do |c|
          reachable_positions.include?([c[:row], c[:col]])
        end
      end

      def remove_duplicates(boxes)
        boxes.uniq { |b| [b.top, b.left, b.bottom, b.right] }
      end
    end
  end
end
