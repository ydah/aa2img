# frozen_string_literal: true

RSpec.describe AA2img::Parser::SectionDetector do
  let(:detector) { described_class.new }
  let(:corner_detector) { AA2img::Parser::CornerDetector.new }
  let(:box_builder) { AA2img::Parser::BoxBuilder.new }

  it "detects section dividers" do
    text = File.read(File.expand_path("../../spec/fixtures/sectioned_box.txt", __dir__))
    grid = AA2img::Grid.new(text)
    corners = corner_detector.detect(grid)
    boxes = box_builder.detect(grid, corners)
    sections = detector.detect(grid, boxes.first)
    expect(sections.size).to eq(3)
  end

  it "returns single section for box without dividers" do
    grid = AA2img::Grid.new("┌──┐\n│hi│\n└──┘")
    corners = corner_detector.detect(grid)
    boxes = box_builder.detect(grid, corners)
    sections = detector.detect(grid, boxes.first)
    expect(sections.size).to eq(1)
  end
end
