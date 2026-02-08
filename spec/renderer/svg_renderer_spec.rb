# frozen_string_literal: true

require "nokogiri"

RSpec.describe AA2img::Renderer::SVGRenderer do
  let(:renderer) { described_class.new }
  let(:theme) { AA2img::Theme.new }

  def parse_fixture(name)
    text = File.read(File.expand_path("../../spec/fixtures/#{name}", __dir__))
    grid = AA2img::Grid.new(text)
    parser = AA2img::Parser::Orchestrator.new(grid)
    parser.parse
  end

  it "renders a simple box as SVG" do
    scene = parse_fixture("simple_unicode_box.txt")
    svg = renderer.render(scene, theme: theme)
    doc = Nokogiri::XML(svg)
    expect(doc.at_css("svg")).not_to be_nil
    rects = doc.css("rect")
    expect(rects.size).to be >= 2
  end

  it "renders labels as text elements" do
    scene = parse_fixture("simple_unicode_box.txt")
    svg = renderer.render(scene, theme: theme)
    doc = Nokogiri::XML(svg)
    texts = doc.css("text")
    text_contents = texts.map(&:text)
    expect(text_contents).to include("Hello")
  end

  it "renders the layered architecture example" do
    scene = parse_fixture("layered_architecture.txt")
    svg = renderer.render(scene, theme: theme)
    doc = Nokogiri::XML(svg)
    rects = doc.css("rect")
    expect(rects.size).to be >= 3
  end

  it "renders layered architecture annotations once each" do
    scene = parse_fixture("layered_architecture.txt")
    svg = renderer.render(scene, theme: theme)
    doc = Nokogiri::XML(svg)

    annotations = doc.css("text").map(&:text).select { |text| text.start_with?("← ") }
    counts = annotations.each_with_object(Hash.new(0)) { |text, tally| tally[text] += 1 }

    expect(counts["← ユーザーとの対話"]).to eq(1)
    expect(counts["← コマンド解析"]).to eq(1)
    expect(counts["← コア機能"]).to eq(1)
    expect(counts["← データ保存"]).to eq(1)
  end

  it "renders annotations with middle baseline alignment" do
    scene = parse_fixture("layered_architecture.txt")
    svg = renderer.render(scene, theme: theme)
    doc = Nokogiri::XML(svg)

    annotation_texts = doc.css("text").select { |node| node.text.start_with?("← ") }
    expect(annotation_texts).not_to be_empty
    expect(annotation_texts.map { |node| node["dominant-baseline"] }.uniq).to eq(["middle"])
  end

  it "aligns annotation y with corresponding labels" do
    scene = parse_fixture("layered_architecture.txt")
    svg = renderer.render(scene, theme: theme, valign: :center)
    doc = Nokogiri::XML(svg)

    pairs = {
      "REPL (UI)" => "← ユーザーとの対話",
      "Command Parser" => "← コマンド解析",
      "Database" => "← コア機能",
      "StringHashMap" => "← データ保存"
    }

    pairs.each do |label_text, annotation_text|
      label_node = doc.css("text").find { |node| node.text == label_text }
      annotation_node = doc.css("text").find { |node| node.text == annotation_text }

      expect(label_node).not_to be_nil
      expect(annotation_node).not_to be_nil
      expect(annotation_node["y"].to_f).to be_within(0.1).of(label_node["y"].to_f)
    end
  end

  it "includes section divider lines" do
    scene = parse_fixture("sectioned_box.txt")
    svg = renderer.render(scene, theme: theme)
    doc = Nokogiri::XML(svg)
    lines = doc.css("line")
    expect(lines.size).to be >= 2
  end

  it "applies blueprint theme" do
    blueprint = AA2img::Theme.load("blueprint")
    scene = parse_fixture("simple_unicode_box.txt")
    svg = renderer.render(scene, theme: blueprint)
    expect(svg).to include("#1A2744")
  end

  describe "valign option" do
    let(:scene) { parse_fixture("layered_architecture.txt") }

    def label_y_values(svg)
      doc = Nokogiri::XML(svg)
      doc.css("text").reject { |t| t.text.include?("←") }
         .map { |t| [t.text.strip, t["y"].to_f] }
         .to_h
    end

    it "shifts labels upward with valign :top" do
      top_positions = label_y_values(renderer.render(scene, theme: theme, valign: :top))
      center_positions = label_y_values(renderer.render(scene, theme: theme, valign: :center))

      expect(top_positions["REPL (UI)"]).to be < center_positions["REPL (UI)"]
      expect(top_positions["Database"]).to be < center_positions["Database"]
    end

    it "shifts labels downward with valign :bottom" do
      center_positions = label_y_values(renderer.render(scene, theme: theme, valign: :center))
      bottom_positions = label_y_values(renderer.render(scene, theme: theme, valign: :bottom))

      expect(center_positions["REPL (UI)"]).to be < bottom_positions["REPL (UI)"]
      expect(center_positions["Database"]).to be < bottom_positions["Database"]
    end

    it "keeps labels above nested child box in all alignments" do
      child_box_rect = Nokogiri::XML(renderer.render(scene, theme: theme))
                       .css("rect")
                       .find { |r| r["fill"] == theme.nested_box_fill }
      child_top_y = child_box_rect["y"].to_f

      %i[top center bottom].each do |valign|
        positions = label_y_values(renderer.render(scene, theme: theme, valign: valign))
        expect(positions["Database"]).to be < child_top_y,
          "valign=#{valign}: Database label y=#{positions["Database"]} should be above child box y=#{child_top_y}"
      end
    end
  end
end
