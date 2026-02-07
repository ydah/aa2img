# frozen_string_literal: true

RSpec.describe "Integration" do
  let(:fixture_dir) { File.expand_path("fixtures", __dir__) }

  describe "layered architecture example" do
    it "parses the full example correctly" do
      text = File.read(File.join(fixture_dir, "layered_architecture.txt"))
      grid = AA2img::Grid.new(text)
      parser = AA2img::Parser::Orchestrator.new(grid)
      scene = parser.parse

      top_boxes = scene.boxes
      expect(top_boxes.size).to eq(1)

      main_box = top_boxes.first
      expect(main_box.sections.size).to be >= 3

      all_labels = main_box.all_labels.map(&:text)
      expect(all_labels).to include("REPL (UI)")
      expect(all_labels).to include("Command Parser")
      expect(all_labels).to include("Database")
    end
  end

  describe "nested box example" do
    it "detects parent-child relationship" do
      text = File.read(File.join(fixture_dir, "nested_box.txt"))
      grid = AA2img::Grid.new(text)
      parser = AA2img::Parser::Orchestrator.new(grid)
      scene = parser.parse

      top_boxes = scene.boxes
      expect(top_boxes.size).to eq(1)
      expect(top_boxes.first.children.size).to eq(1)
    end
  end

  describe "multiple boxes" do
    it "detects independent boxes" do
      text = File.read(File.join(fixture_dir, "multiple_boxes.txt"))
      grid = AA2img::Grid.new(text)
      parser = AA2img::Parser::Orchestrator.new(grid)
      scene = parser.parse

      expect(scene.boxes.size).to eq(2)
    end
  end

  describe "empty input" do
    it "returns empty scene" do
      grid = AA2img::Grid.new("")
      parser = AA2img::Parser::Orchestrator.new(grid)
      scene = parser.parse
      expect(scene.boxes).to be_empty
    end
  end

  describe "no boxes" do
    it "returns empty scene for plain text" do
      text = File.read(File.join(fixture_dir, "no_boxes.txt"))
      grid = AA2img::Grid.new(text)
      parser = AA2img::Parser::Orchestrator.new(grid)
      scene = parser.parse
      expect(scene.boxes).to be_empty
    end
  end

  describe "SVG end-to-end" do
    it "generates valid SVG from fixture" do
      text = File.read(File.join(fixture_dir, "layered_architecture.txt"))
      svg = AA2img.convert(text, format: :svg)
      expect(svg).to include("<svg")
      expect(svg).to include("</svg>")
    end

    it "generates SVG with all themes" do
      text = File.read(File.join(fixture_dir, "simple_unicode_box.txt"))
      AA2img::Theme.available.each do |theme_name|
        svg = AA2img.convert(text, format: :svg, theme: theme_name)
        expect(svg).to include("<svg")
      end
    end
  end
end
