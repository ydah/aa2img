# frozen_string_literal: true

RSpec.describe Aa2Img::Parser::CornerDetector do
  let(:detector) { described_class.new }

  it "detects Unicode corners" do
    grid = Aa2Img::Grid.new("┌──┐\n│  │\n└──┘")
    corners = detector.detect(grid)
    types = corners.map { |c| c[:type] }
    expect(types).to include(:top_left, :top_right, :bottom_left, :bottom_right)
  end

  it "detects ASCII corners from +" do
    grid = Aa2Img::Grid.new("+--+\n|  |\n+--+")
    corners = detector.detect(grid)
    types = corners.map { |c| c[:type] }
    expect(types).to include(:top_left, :top_right, :bottom_left, :bottom_right)
  end

  it "detects T-junctions" do
    grid = Aa2Img::Grid.new("┌──┐\n├──┤\n└──┘")
    corners = detector.detect(grid)
    types = corners.map { |c| c[:type] }
    expect(types).to include(:left, :right)
  end
end
