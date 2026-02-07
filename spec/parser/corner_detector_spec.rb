# frozen_string_literal: true

RSpec.describe AA2img::Parser::CornerDetector do
  let(:detector) { described_class.new }

  it "detects Unicode corners" do
    grid = AA2img::Grid.new("┌──┐\n│  │\n└──┘")
    corners = detector.detect(grid)
    types = corners.map { |c| c[:type] }
    expect(types).to include(:top_left, :top_right, :bottom_left, :bottom_right)
  end

  it "detects ASCII corners from +" do
    grid = AA2img::Grid.new("+--+\n|  |\n+--+")
    corners = detector.detect(grid)
    types = corners.map { |c| c[:type] }
    expect(types).to include(:top_left, :top_right, :bottom_left, :bottom_right)
  end

  it "detects T-junctions" do
    grid = AA2img::Grid.new("┌──┐\n├──┤\n└──┘")
    corners = detector.detect(grid)
    types = corners.map { |c| c[:type] }
    expect(types).to include(:left, :right)
  end
end
