require 'fog/core/collection'
require 'fog/storm_on_demand/models/billing/payment'

module Fog
  module Billing
    class StormOnDemand
      class Payments < Fog::Collection
        model Fog::Billing::StormOnDemand::Payment

        def make(amount, card_code)
          service.make_payment(:amount => amount,
                               :card_code => card_code).body['amount']
        end
      end
    end
  end
end
