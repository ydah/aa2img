# frozen_string_literal: true

RSpec.describe AA2img::AST::Box do
  it "deduplicates annotations collected from both box and section" do
    annotation = AA2img::AST::Annotation.new(text: "note", row: 1, arrow_col: 10)
    section = AA2img::AST::Section.new(top: 0, bottom: 2, annotation: annotation)

    box = described_class.new(
      top: 0, left: 0, bottom: 2, right: 10,
      annotations: [annotation],
      sections: [section]
    )

    expect(box.all_annotations).to eq([annotation])
  end
end
