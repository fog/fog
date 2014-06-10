require 'fog/core/model'

module Fog
  module Network
    class StormOnDemand
      class Ruleset < Fog::Model
        attribute :accnt
        attribute :destination_ip
        attribute :rules
        attribute :ruleset
        attribute :uniq_id

        def initialize(attributes={})
          super
        end

        def update(rules)
          requires :ruleset
          service.update_ruleset(:ruleset => ruleset, :rules => rules)
          true
        end
      end
    end
  end
end
