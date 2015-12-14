require 'active_support/concern'
require 'set'

module Represent
  module Exposure
    extend ActiveSupport::Concern

    included do
      class_attribute :_exposures
      self._exposures ||= Set.new

      before_action :assign_exposures
    end

    module ClassMethods
      def expose(key)
        _exposures << key
      end
    end

  protected

    def assign_exposures
      self.class._exposures.each do |key|
        expose key
      end
    end

  private

    def expose(key, value=nil)
      value = send(key) unless value
      view_assigns[key] = value
    end
  end
end
