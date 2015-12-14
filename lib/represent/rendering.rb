require 'active_support/concern'

module Represent
  module Rendering
    extend ActiveSupport::Concern

    Error = Class.new(StandardError)
    MissingView = Class.new(Error)

    included do
      self.view_paths = Rails.configuration.paths['app/templates']
    end

    def view_assigns
      @view_assigns ||= {}
    end

    def view_context_class
      view_context_class = view_context_class_name.constantize

      supports_path = self.class.supports_path?
      routes  = respond_to?(:_routes)  && _routes
      helpers = respond_to?(:_helpers) && _helpers

      Class.new(view_context_class) do
        if routes
          include routes.url_helpers(supports_path)
          include routes.mounted_helpers
        end

        if helpers
          include helpers
        end
      end
    rescue NameError
      raise MissingView, "Could not find view: #{view_context_class_name}"
    end

  private

    def _process_options(options)
      if locals = options.delete(:locals)
        view_assigns.update locals
      end

      super
    end

    def view_context_class_name
      @_view_context_class_name ||= begin
        controller = self.class.name.sub(/Controller$/, '').underscore
        action = action_name + '_view'

        File.join(controller, action).camelize
      end
    end
  end
end
