# frozen_string_literal: true

require "tmpdir"
require "yaml"

RSpec.describe Aa2Img::Theme do
  describe ".available" do
    it "includes built-in modern theme" do
      expect(described_class.available).to include("modern")
    end
  end

  describe ".load" do
    it "loads built-in theme by name" do
      theme = described_class.load("modern")
      expect(theme.name).to eq("modern")
      expect(theme.box_fill).to eq("#FFFFFF")
    end

    it "loads theme from YAML file path" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "custom_theme.yml")
        File.write(path, {
          "name" => "custom",
          "box_fill" => "#123456",
          "metrics" => { "padding" => 48 }
        }.to_yaml)

        theme = described_class.load(path)
        expect(theme.name).to eq("custom")
        expect(theme.box_fill).to eq("#123456")
        expect(theme.metrics["padding"]).to eq(48)
      end
    end

    it "raises a clear error for missing theme file path" do
      expect do
        described_class.load("./not_found_theme.yml")
      end.to raise_error(ArgumentError, "Theme file not found: ./not_found_theme.yml")
    end
  end
end
