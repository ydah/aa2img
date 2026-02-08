# frozen_string_literal: true

RSpec.describe AA2img::Layout::Calculator do
  let(:theme) { AA2img::Theme.new }
  let(:cell_height) { theme.metrics["cell_height"] }
  let(:padding) { theme.metrics["padding"] }

  def build_scene(width: 40, height: 10)
    scene = AA2img::AST::Scene.new
    scene.width = width
    scene.height = height
    scene
  end

  def make_label(text, row:)
    AA2img::AST::Label.new(text: text, row: row, col: 0, align: :center)
  end

  describe "#label_position with valign" do
    context "section without children" do
      let(:scene) { build_scene }
      let(:calc) { described_class.new(scene, theme) }
      let(:box) { AA2img::AST::Box.new(top: 0, left: 0, bottom: 4, right: 20) }
      let(:section) { AA2img::AST::Section.new(top: 0, bottom: 4) }
      let(:label) { make_label("Hello", row: 1) }

      it "positions label near section top with valign :top" do
        pos_top = calc.label_position(label, box, section: section, valign: :top)
        pos_center = calc.label_position(label, box, section: section, valign: :center)
        pos_bottom = calc.label_position(label, box, section: section, valign: :bottom)

        expect(pos_top[:y]).to be < pos_center[:y]
        expect(pos_center[:y]).to be < pos_bottom[:y]
      end
    end

    context "section with child box" do
      let(:scene) { build_scene }
      let(:calc) { described_class.new(scene, theme) }
      let(:box) { AA2img::AST::Box.new(top: 0, left: 0, bottom: 10, right: 38) }
      let(:child) { AA2img::AST::Box.new(top: 4, left: 3, bottom: 8, right: 33) }
      let(:section) { AA2img::AST::Section.new(top: 0, bottom: 10) }
      let(:label) { make_label("Database", row: 1) }

      it "keeps label above child box region with valign :top" do
        child_top_y = padding + child.top * cell_height

        pos = calc.label_position(label, box, section: section, valign: :top, children: [child])
        expect(pos[:y]).to be < child_top_y
      end

      it "keeps label above child box region with valign :center" do
        child_top_y = padding + child.top * cell_height

        pos = calc.label_position(label, box, section: section, valign: :center, children: [child])
        expect(pos[:y]).to be < child_top_y
      end

      it "keeps label above child box region with valign :bottom" do
        child_top_y = padding + child.top * cell_height

        pos = calc.label_position(label, box, section: section, valign: :bottom, children: [child])
        expect(pos[:y]).to be < child_top_y
      end

      it "does not affect sections without children" do
        other_section = AA2img::AST::Section.new(top: 0, bottom: 2)
        other_label = make_label("Header", row: 1)

        pos_with = calc.label_position(other_label, box, section: other_section, valign: :center, children: [child])
        pos_without = calc.label_position(other_label, box, section: other_section, valign: :center, children: [])

        expect(pos_with[:y]).to eq(pos_without[:y])
      end
    end

    context "multiple labels in a section" do
      let(:scene) { build_scene }
      let(:calc) { described_class.new(scene, theme) }
      let(:box) { AA2img::AST::Box.new(top: 0, left: 0, bottom: 10, right: 38) }
      let(:child) { AA2img::AST::Box.new(top: 5, left: 3, bottom: 9, right: 33) }
      let(:section) { AA2img::AST::Section.new(top: 0, bottom: 10) }
      let(:label_a) { make_label("Line A", row: 1) }
      let(:label_b) { make_label("Line B", row: 2) }

      it "orders labels sequentially" do
        pos_a = calc.label_position(label_a, box, section: section, valign: :top, label_index: 0, label_count: 2, children: [child])
        pos_b = calc.label_position(label_b, box, section: section, valign: :top, label_index: 1, label_count: 2, children: [child])

        expect(pos_a[:y]).to be < pos_b[:y]
      end

      it "keeps all labels outside child box region" do
        child_top_y = padding + child.top * cell_height

        [0, 1].each do |idx|
          pos = calc.label_position(label_a, box, section: section, valign: :bottom, label_index: idx, label_count: 2, children: [child])
          expect(pos[:y]).to be < child_top_y
        end
      end
    end
  end

  describe "#annotation_position" do
    let(:scene) { build_scene }
    let(:calc) { described_class.new(scene, theme) }
    let(:box) { AA2img::AST::Box.new(top: 0, left: 0, bottom: 4, right: 20) }
    let(:annotation) { AA2img::AST::Annotation.new(text: "note", row: 2, arrow_col: 21) }

    it "centers annotation vertically within its row" do
      pos = calc.annotation_position(annotation, box)
      expected_center_y = padding + annotation.row * cell_height + cell_height * 0.5

      expect(pos[:y]).to eq(expected_center_y)
    end
  end
end
