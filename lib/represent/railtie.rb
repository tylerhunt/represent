require 'rails/railtie'
require 'represent'

module Represent
  class Railtie < Rails::Railtie
    initializer 'represent.load_paths', before: :set_autoload_paths do |app|
      # The app/views path is normally excluded from autoloading, since it only
      # contains templates, but we now want to load Ruby classes from there.
      app.config.eager_load_paths += app.config.paths['app/views'].existent
    end

    initializer :represent do |app|
      app.config.paths['app/templates'] = 'app/templates'

      ActiveSupport.on_load(:action_controller) do
        include Represent::Rendering
      end
    end
  end
end
