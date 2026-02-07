# frozen_string_literal: true

RSpec.describe Aa2Img do
  it "has a version number" do
    expect(Aa2Img::VERSION).not_to be_nil
  end

  describe ".convert" do
    it "converts AA text to SVG" do
      aa = <<~AA
        ┌──────┐
        │ Test │
        └──────┘
      AA
      result = Aa2Img.convert(aa, format: :svg)
      expect(result).to include("<svg")
      expect(result).to include("Test")
    end

    it "raises for unsupported format" do
      expect { Aa2Img.convert("test", format: :gif) }.to raise_error(ArgumentError)
    end
  end

  describe ".convert_to_file" do
    it "writes SVG to file" do
      aa = <<~AA
        ┌──────┐
        │ Test │
        └──────┘
      AA
      Dir.mktmpdir do |dir|
        path = File.join(dir, "output.svg")
        Aa2Img.convert_to_file(aa, path)
        expect(File.exist?(path)).to be true
        expect(File.read(path)).to include("<svg")
      end
    end
  end
end
