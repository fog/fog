require 'fog/core/model'

module Fog
  module StormOnDemand
    class Compute

      class Stat < Fog::Model
        attribute :loadavg
        attribute :memory
        attribute :virtual
        attribute :domain
        attribute :disk
        attribute :uptime
        
        def initialize(attributes={})
          super
        end

      end

    end
  end
end
