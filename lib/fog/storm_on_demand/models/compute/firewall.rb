require 'fog/core/model'

module Fog
  module Compute
    class StormOnDemand

      class Firewall < Fog::Model
        attribute :allow
        attribute :rules
        attribute :ruleset
        attribute :type

        def initialize(attributes={})
          super
        end

      end
    end
  end
end
