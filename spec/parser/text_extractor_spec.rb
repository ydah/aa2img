# frozen_string_literal: true

RSpec.describe Aa2Img::Parser::TextExtractor do
  let(:extractor) { described_class.new }

  it "extracts labels from a section" do
    grid = Aa2Img::Grid.new("┌──────┐\n│ Test │\n└──────┘")
    box = Aa2Img::AST::Box.new(top: 0, left: 0, bottom: 2, right: 7)
    section = Aa2Img::AST::Section.new(top: 0, bottom: 2)
    labels = extractor.extract_labels(grid, section, box)
    expect(labels.size).to eq(1)
    expect(labels.first.text).to eq("Test")
  end

  it "extracts annotations" do
    grid = Aa2Img::Grid.new("┌──┐  ← comment\n│hi│\n└──┘")
    box = Aa2Img::AST::Box.new(top: 0, left: 0, bottom: 2, right: 3)
    annotations = extractor.extract_annotations(grid, box)
    expect(annotations.size).to eq(1)
    expect(annotations.first.text).to eq("comment")
  end

  it "returns empty for no text" do
    grid = Aa2Img::Grid.new("┌──┐\n│  │\n└──┘")
    box = Aa2Img::AST::Box.new(top: 0, left: 0, bottom: 2, right: 3)
    section = Aa2Img::AST::Section.new(top: 0, bottom: 2)
    labels = extractor.extract_labels(grid, section, box)
    expect(labels).to be_empty
  end
end
