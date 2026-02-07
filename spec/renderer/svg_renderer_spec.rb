# frozen_string_literal: true

require "nokogiri"

RSpec.describe Aa2Img::Renderer::SVGRenderer do
  let(:renderer) { described_class.new }
  let(:theme) { Aa2Img::Theme.new }

  def parse_fixture(name)
    text = File.read(File.expand_path("../../spec/fixtures/#{name}", __dir__))
    grid = Aa2Img::Grid.new(text)
    parser = Aa2Img::Parser::Orchestrator.new(grid)
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

  it "includes section divider lines" do
    scene = parse_fixture("sectioned_box.txt")
    svg = renderer.render(scene, theme: theme)
    doc = Nokogiri::XML(svg)
    lines = doc.css("line")
    expect(lines.size).to be >= 2
  end

  it "applies blueprint theme" do
    blueprint = Aa2Img::Theme.load("blueprint")
    scene = parse_fixture("simple_unicode_box.txt")
    svg = renderer.render(scene, theme: blueprint)
    expect(svg).to include("#1A2744")
  end
end
