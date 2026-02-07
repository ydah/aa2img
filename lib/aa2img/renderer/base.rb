# frozen_string_literal: true

module AA2img
  module Renderer
    class Base
      def render(_scene, **_options)
        raise NotImplementedError, "#{self.class}#render must be implemented"
      end
    end
  end
end
