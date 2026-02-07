# frozen_string_literal: true

require "nokogiri"

module Aa2Img
  module Renderer
    class SVGRenderer < Base
      def render(scene, theme:, **_options)
        calculator = Layout::Calculator.new(scene, theme)
        svg_width = calculator.total_width
        svg_height = calculator.total_height

        builder = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
          xml.svg(
            xmlns: "http://www.w3.org/2000/svg",
            width: svg_width,
            height: svg_height,
            viewBox: "0 0 #{svg_width} #{svg_height}"
          ) do
            xml.defs do
              xml.style(type: "text/css") do
                xml.text "@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP');"
              end

              xml.marker(
                id: "arrowhead",
                markerWidth: 10,
                markerHeight: 7,
                refX: 10,
                refY: 3.5,
                orient: "auto"
              ) do
                xml.polygon(points: "0 0, 10 3.5, 0 7", fill: theme.arrow_color)
              end
            end

            xml.rect(
              x: 0, y: 0,
              width: svg_width, height: svg_height,
              fill: theme.background_color
            )

            scene.elements.each do |el|
              case el
              when AST::Box then render_box(xml, el, calculator, theme, 0)
              when AST::Edge then render_edge(xml, el, calculator, theme)
              end
            end
          end
        end

        builder.to_xml
      end

      private

      def render_box(xml, box, calc, theme, depth)
        rect = calc.box_rect(box)
        fill = depth > 0 ? theme.nested_box_fill : theme.box_fill

        xml.rect(
          x: rect[:x], y: rect[:y],
          width: rect[:width], height: rect[:height],
          rx: theme.border_radius, ry: theme.border_radius,
          fill: fill,
          stroke: theme.box_stroke,
          "stroke-width": theme.box_stroke_width
        )

        (box.sections || [])[1..]&.each do |section|
          y = calc.to_px(section.top, 0)[:y]
          xml.line(
            x1: rect[:x], y1: y,
            x2: rect[:x] + rect[:width], y2: y,
            stroke: theme.box_stroke,
            "stroke-width": theme.box_stroke_width
          )
        end

        box.all_labels.each do |label|
          pos = calc.label_position(label, box)
          xml.text_(
            x: pos[:x], y: pos[:y],
            "text-anchor": "middle",
            "dominant-baseline": "middle",
            "font-family": theme.font_family,
            "font-size": theme.font_size,
            fill: theme.text_color
          ) { xml.text label.text }
        end

        box.all_annotations.each do |ann|
          pos = calc.annotation_position(ann, box)
          xml.text_(
            x: pos[:x], y: pos[:y],
            "font-family": theme.font_family,
            "font-size": theme.annotation_font_size,
            fill: theme.annotation_color,
            "font-style": "italic"
          ) { xml.text "← #{ann.text}" }
        end

        (box.children || []).each do |child|
          render_box(xml, child, calc, theme, depth + 1)
        end
      end

      def render_edge(xml, edge, calc, theme)
        from = calc.to_px(edge.from[:row], edge.from[:col])
        to_pos = calc.to_px(edge.to[:row], edge.to[:col])

        attrs = {
          x1: from[:x], y1: from[:y],
          x2: to_pos[:x], y2: to_pos[:y],
          stroke: theme.arrow_color,
          "stroke-width": 2
        }
        attrs["stroke-dasharray"] = "5,5" if edge.style == :dashed
        attrs["marker-end"] = "url(#arrowhead)" if %i[forward both].include?(edge.arrow)
        attrs["marker-start"] = "url(#arrowhead-reverse)" if %i[backward both].include?(edge.arrow)

        xml.line(**attrs)
      end
    end
  end
end
