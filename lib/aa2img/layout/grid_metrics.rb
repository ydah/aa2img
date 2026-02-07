# frozen_string_literal: true

module AA2img
  module Layout
    class GridMetrics
      DEFAULT = {
        cell_width: 10,
        cell_height: 20,
        padding: 20
      }.freeze

      attr_reader :cell_width, :cell_height, :padding

      def initialize(config = {})
        merged = DEFAULT.merge(config || {})
        @cell_width = merged[:cell_width] || merged["cell_width"]
        @cell_height = merged[:cell_height] || merged["cell_height"]
        @padding = merged[:padding] || merged["padding"]
      end
    end
  end
end
