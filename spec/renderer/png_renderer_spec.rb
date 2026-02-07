# frozen_string_literal: true

RSpec.describe Aa2Img::Renderer::PNGRenderer do
  let(:renderer) { described_class.new }
  let(:theme) { Aa2Img::Theme.new }

  it "renders PNG with correct signature", skip: "Requires ImageMagick" do
    grid = Aa2Img::Grid.new("┌──┐\n│hi│\n└──┘")
    parser = Aa2Img::Parser::Orchestrator.new(grid)
    scene = parser.parse
    png = renderer.render(scene, theme: theme)
    expect(png[0..3].bytes).to eq([137, 80, 78, 71])
  end
end
