# frozen_string_literal: true

require_relative "lib/aa2img/version"

Gem::Specification.new do |spec|
  spec.name = "aa2img"
  spec.version = Aa2Img::VERSION
  spec.authors = ["Yudai Takada"]
  spec.email = ["t.yudai92@gmail.com"]

  spec.summary = "Convert ASCII Art diagrams to SVG/PNG images"
  spec.description = "A Ruby gem that parses ASCII art (box diagrams, layered architecture, flowcharts) and renders them as clean SVG or PNG images."
  spec.homepage = "https://github.com/ydah/aa2img"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ydah/aa2img"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.16"
  spec.add_dependency "thor", "~> 1.3"
  spec.add_dependency "unicode-display_width", "~> 2.5"
  spec.add_dependency "mini_magick", "~> 4.12"
end
