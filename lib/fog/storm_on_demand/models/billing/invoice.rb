require 'fog/core/model'

module Fog
  module Billing
    class StormOnDemand

      class Invoice < Fog::Model
        identity :id
        attribute :accnt
        attribute :bill_date
        attribute :due
        attribute :end_date
        attribute :lineitem_groups
        attribute :payments
        attribute :start_date
        attribute :status
        attribute :total
        attribute :type

        def initialize(attributes={})
          super
        end

      end

    end
  end
end
