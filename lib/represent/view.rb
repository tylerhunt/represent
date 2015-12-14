require 'action_view'

module Represent
  # Overrides the assigns functionality of Action View to use on attribute
  # assignment on the view instead of manually setting instance variables.
  class View < ActionView::Base
    def initialize(context, assigns, controller)
      assign assigns
      super context, {}, controller
    end

  private

    def assign(assigns)
      @_assigns = assigns.each do |key, value|
        send :"#{key}=", value
      end
    end
  end
end
