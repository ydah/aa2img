# frozen_string_literal: true

module AA2img
  module Parser
    module CharClassifier
      CORNERS = {
        top_left: %w[┌ ╔ ┏ +],
        top_right: %w[┐ ╗ ┓ +],
        bottom_left: %w[└ ╚ ┗ +],
        bottom_right: %w[┘ ╝ ┛ +]
      }.freeze

      HORIZONTALS = %w[─ ━ ═ -].freeze
      VERTICALS = %w[│ ┃ ║ |].freeze

      T_JUNCTIONS = {
        left: %w[├ ╠ ┣],
        right: %w[┤ ╣ ┫],
        top: %w[┬ ╦ ┳],
        bottom: %w[┴ ╩ ┻],
        cross: %w[┼ ╬ ╋]
      }.freeze

      ARROW_HEADS = %w[> < ^ v ▶ ◀ ▲ ▼ → ← ↑ ↓].freeze

      ALL_CORNERS = CORNERS.values.flatten.uniq.freeze
      ALL_T_JUNCTIONS = T_JUNCTIONS.values.flatten.uniq.freeze

      def self.corner?(ch)
        ALL_CORNERS.include?(ch)
      end

      def self.horizontal?(ch)
        HORIZONTALS.include?(ch)
      end

      def self.vertical?(ch)
        VERTICALS.include?(ch)
      end

      def self.t_junction?(ch)
        ALL_T_JUNCTIONS.include?(ch)
      end

      def self.structural?(ch)
        corner?(ch) || horizontal?(ch) || vertical?(ch) || t_junction?(ch)
      end

      def self.arrow_head?(ch)
        ARROW_HEADS.include?(ch)
      end

      def self.corner_type(ch)
        CORNERS.each do |type, chars|
          return type if chars.include?(ch) && ch != "+"
        end
        nil
      end

      def self.t_junction_type(ch)
        T_JUNCTIONS.each do |type, chars|
          return type if chars.include?(ch)
        end
        nil
      end
    end
  end
end
