require 'active_support/concern'
require 'represent/rendering'

module Represent
  # When included into a controller, this module will allow :locals options
  # given to the #render method to be intercepted and used to inject values
  # into the view model.
  module AssignLocals
    extend ActiveSupport::Concern
    include Rendering

  private

    def _process_options(options)
      if locals = options.delete(:locals)
        view_assigns.update locals
      end

      super
    end
  end
end
