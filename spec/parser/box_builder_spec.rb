# frozen_string_literal: true

RSpec.describe Aa2Img::Parser::BoxBuilder do
  let(:builder) { described_class.new }
  let(:corner_detector) { Aa2Img::Parser::CornerDetector.new }

  it "detects a simple Unicode box" do
    grid = Aa2Img::Grid.new("┌──┐\n│  │\n└──┘")
    corners = corner_detector.detect(grid)
    boxes = builder.detect(grid, corners)
    expect(boxes.size).to eq(1)
    expect(boxes.first.top).to eq(0)
    expect(boxes.first.left).to eq(0)
    expect(boxes.first.bottom).to eq(2)
    expect(boxes.first.right).to eq(3)
  end

  it "detects a simple ASCII box" do
    grid = Aa2Img::Grid.new("+--+\n|  |\n+--+")
    corners = corner_detector.detect(grid)
    boxes = builder.detect(grid, corners)
    expect(boxes.size).to eq(1)
  end

  it "detects multiple independent boxes" do
    text = File.read(File.expand_path("../../spec/fixtures/multiple_boxes.txt", __dir__))
    grid = Aa2Img::Grid.new(text)
    corners = corner_detector.detect(grid)
    boxes = builder.detect(grid, corners)
    expect(boxes.size).to eq(2)
  end

  it "returns empty for no boxes" do
    grid = Aa2Img::Grid.new("hello world")
    corners = corner_detector.detect(grid)
    boxes = builder.detect(grid, corners)
    expect(boxes).to be_empty
  end
end
