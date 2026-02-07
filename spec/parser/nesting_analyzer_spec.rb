# frozen_string_literal: true

RSpec.describe AA2img::Parser::NestingAnalyzer do
  let(:analyzer) { described_class.new }

  it "identifies parent-child relationships" do
    outer = AA2img::AST::Box.new(top: 0, left: 0, bottom: 10, right: 20)
    inner = AA2img::AST::Box.new(top: 2, left: 2, bottom: 8, right: 18)
    top_level = analyzer.analyze([outer, inner])
    expect(top_level.size).to eq(1)
    expect(top_level.first).to eq(outer)
    expect(outer.children).to include(inner)
  end

  it "handles non-nested boxes" do
    box1 = AA2img::AST::Box.new(top: 0, left: 0, bottom: 5, right: 5)
    box2 = AA2img::AST::Box.new(top: 0, left: 10, bottom: 5, right: 15)
    top_level = analyzer.analyze([box1, box2])
    expect(top_level.size).to eq(2)
  end
end
