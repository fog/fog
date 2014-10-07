require 'fog/core/model'

module Fog
  module Compute
    class StormOnDemand
      class Notification < Fog::Model
        identity :id
        attribute :category
        attribute :description
        attribute :enddate
        attribute :last_alert
        attribute :modifieddate
        attribute :resolved
        attribute :severity
        attribute :startdate
        attribute :system
        attribute :system_identifier
        attribute :uniq_id

        def initialize(attributes={})
          super
        end

        def resolve
          requires :identity
          service.resolve_notification(:id => identity).body
        end
      end
    end
  end
end
