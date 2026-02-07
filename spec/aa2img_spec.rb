# frozen_string_literal: true

RSpec.describe AA2img do
  it "has a version number" do
    expect(AA2img::VERSION).not_to be_nil
  end

  describe ".convert" do
    it "converts AA text to SVG" do
      aa = <<~AA
        ┌──────┐
        │ Test │
        └──────┘
      AA
      result = AA2img.convert(aa, format: :svg)
      expect(result).to include("<svg")
      expect(result).to include("Test")
    end

    it "raises for unsupported format" do
      expect { AA2img.convert("test", format: :gif) }.to raise_error(ArgumentError)
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
        AA2img.convert_to_file(aa, path)
        expect(File.exist?(path)).to be true
        expect(File.read(path)).to include("<svg")
      end
    end
  end
end
