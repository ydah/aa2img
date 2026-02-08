# frozen_string_literal: true

RSpec.describe AA2img::Parser::TextExtractor do
  let(:extractor) { described_class.new }

  it "extracts labels from a section" do
    grid = AA2img::Grid.new("┌──────┐\n│ Test │\n└──────┘")
    box = AA2img::AST::Box.new(top: 0, left: 0, bottom: 2, right: 7)
    section = AA2img::AST::Section.new(top: 0, bottom: 2)
    labels = extractor.extract_labels(grid, section, box)
    expect(labels.size).to eq(1)
    expect(labels.first.text).to eq("Test")
  end

  it "extracts annotations" do
    grid = AA2img::Grid.new("┌──┐  ← comment\n│hi│\n└──┘")
    box = AA2img::AST::Box.new(top: 0, left: 0, bottom: 2, right: 3)
    annotations = extractor.extract_annotations(grid, box)
    expect(annotations.size).to eq(1)
    expect(annotations.first.text).to eq("comment")
  end

  it "ignores child-row annotations when extracting parent annotations" do
    text = <<~DIAGRAM
      ┌─────────────────────────────────────┐
      │           Database                  │
      │  ┌─────────────────────────────┐    │
      │  │       StringHashMap         │    │  ← データ保存
      │  └─────────────────────────────┘    │
      └─────────────────────────────────────┘
    DIAGRAM
    grid = AA2img::Grid.new(text)

    corner_detector = AA2img::Parser::CornerDetector.new
    corners = corner_detector.detect(grid)
    boxes = AA2img::Parser::BoxBuilder.new.detect(grid, corners)
    parent = AA2img::Parser::NestingAnalyzer.new.analyze(boxes).first

    annotations = extractor.extract_annotations(grid, parent, children: parent.children)
    expect(annotations).to be_empty
  end

  it "returns empty for no text" do
    grid = AA2img::Grid.new("┌──┐\n│  │\n└──┘")
    box = AA2img::AST::Box.new(top: 0, left: 0, bottom: 2, right: 3)
    section = AA2img::AST::Section.new(top: 0, bottom: 2)
    labels = extractor.extract_labels(grid, section, box)
    expect(labels).to be_empty
  end
end
