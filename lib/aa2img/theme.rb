# frozen_string_literal: true

require "yaml"

module Aa2Img
  class Theme
    DEFAULTS = {
      "name" => "default",
      "background_color" => "#FFFFFF",
      "box_fill" => "#F8F9FA",
      "box_stroke" => "#343A40",
      "box_stroke_width" => 2,
      "border_radius" => 6,
      "text_color" => "#212529",
      "font_family" => "'Noto Sans JP', Helvetica, Arial, sans-serif",
      "font_size" => 14,
      "annotation_font_size" => 12,
      "annotation_color" => "#6C757D",
      "arrow_color" => "#495057",
      "nested_box_fill" => "#E9ECEF",
      "section_header_fill" => "#DEE2E6",
      "metrics" => {
        "cell_width" => 10,
        "cell_height" => 20,
        "padding" => 20
      }
    }.freeze

    THEME_ATTRIBUTES = %w[
      name background_color box_fill box_stroke box_stroke_width
      border_radius text_color font_family font_size
      annotation_font_size annotation_color arrow_color
      nested_box_fill section_header_fill metrics
    ].freeze

    attr_reader :config

    THEME_ATTRIBUTES.each do |attr|
      define_method(attr) { @config[attr] }
    end

    def initialize(config = {})
      @config = deep_merge(DEFAULTS, stringify_keys(config))
    end

    def self.load(theme)
      case theme
      when Theme
        theme
      when Hash
        new(theme)
      when String, Symbol
        load_by_identifier(theme.to_s)
      else
        new
      end
    end

    def self.load_by_identifier(identifier)
      if (path = resolve_theme_file_path(identifier))
        return load_from_path(path)
      end

      return load_by_name(identifier) if available.include?(identifier)

      raise ArgumentError, "Theme file not found: #{identifier}" if path_like?(identifier)

      raise ArgumentError, "Unknown theme: #{identifier}. Available themes: #{available.join(', ')}"
    end

    def self.load_by_name(name)
      path = theme_path(name)
      raise ArgumentError, "Unknown theme: #{name}" unless File.exist?(path)

      load_from_path(path)
    end

    def self.load_from_path(path)
      config = YAML.safe_load_file(path)
      new(config || {})
    end

    def self.available
      Dir.glob(File.join(themes_dir, "*.yml")).map do |path|
        File.basename(path, ".yml")
      end.sort
    end

    def self.themes_dir
      File.expand_path("../../themes", __dir__)
    end

    def self.theme_path(name)
      File.join(themes_dir, "#{name}.yml")
    end

    def self.resolve_theme_file_path(identifier)
      expanded = File.expand_path(identifier)
      return expanded if File.file?(expanded)

      nil
    end

    def self.path_like?(identifier)
      identifier.include?(File::SEPARATOR) ||
        identifier.end_with?(".yml", ".yaml") ||
        identifier.start_with?(".", "~")
    end

    private

    def deep_merge(base, override)
      base.merge(override) do |_key, old_val, new_val|
        if old_val.is_a?(Hash) && new_val.is_a?(Hash)
          deep_merge(old_val, new_val)
        else
          new_val
        end
      end
    end

    def stringify_keys(hash)
      return {} unless hash.is_a?(Hash)

      hash.transform_keys(&:to_s).transform_values do |v|
        v.is_a?(Hash) ? stringify_keys(v) : v
      end
    end
  end
end
