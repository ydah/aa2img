# frozen_string_literal: true

RSpec.describe AA2img::AST::Scene do
  it "initializes with empty elements" do
    scene = described_class.new
    expect(scene.elements).to be_empty
  end

  it "collects all boxes including nested" do
    scene = described_class.new
    outer = AA2img::AST::Box.new(top: 0, left: 0, bottom: 10, right: 20)
    inner = AA2img::AST::Box.new(top: 2, left: 2, bottom: 8, right: 18)
    outer.add_child(inner)
    scene.elements = [outer]
    expect(scene.all_boxes.size).to eq(2)
  end

  it "generates tree string" do
    scene = described_class.new
    scene.width = 10
    scene.height = 5
    result = scene.to_tree_string
    expect(result).to include("Scene")
    expect(result).to include("10")
  end
end
