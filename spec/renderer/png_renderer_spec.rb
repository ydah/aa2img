# frozen_string_literal: true

RSpec.describe AA2img::Renderer::PNGRenderer do
  let(:renderer) { described_class.new }
  let(:theme) { AA2img::Theme.new }

  it "renders PNG with correct signature", skip: "Requires ImageMagick" do
    grid = AA2img::Grid.new("┌──┐\n│hi│\n└──┘")
    parser = AA2img::Parser::Orchestrator.new(grid)
    scene = parser.parse
    png = renderer.render(scene, theme: theme)
    expect(png[0..3].bytes).to eq([137, 80, 78, 71])
  end
end
