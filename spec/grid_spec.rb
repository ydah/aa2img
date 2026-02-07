# frozen_string_literal: true

RSpec.describe Aa2Img::Grid do
  describe "#initialize" do
    it "creates a grid from ASCII text" do
      grid = Aa2Img::Grid.new("abc\ndef")
      expect(grid.height).to eq(2)
      expect(grid.width).to eq(3)
    end

    it "pads shorter lines with spaces" do
      grid = Aa2Img::Grid.new("ab\na")
      expect(grid.at(1, 1)).to eq(" ")
    end

    it "handles empty input" do
      grid = Aa2Img::Grid.new("")
      expect(grid.height).to eq(0)
    end

    it "handles Japanese characters with proper width" do
      grid = Aa2Img::Grid.new("あ")
      expect(grid.at(0, 0)).to eq("あ")
      expect(grid.at(0, 1)).to eq(:wide_placeholder)
    end
  end

  describe "#at" do
    it "returns nil for out-of-bounds coordinates" do
      grid = Aa2Img::Grid.new("ab")
      expect(grid.at(-1, 0)).to be_nil
      expect(grid.at(0, 5)).to be_nil
    end

    it "returns the character at the given position" do
      grid = Aa2Img::Grid.new("abc")
      expect(grid.at(0, 1)).to eq("b")
    end
  end
end
