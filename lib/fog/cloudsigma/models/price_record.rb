require 'fog/cloudsigma/nested_model'
require 'bigdecimal'

module Fog
  module Compute
    class CloudSigma
      class PriceRecord < Fog::CloudSigma::CloudsigmaModel
        attribute :resource, :type => :string
        attribute :multiplier, :type => :integer
        attribute :price, :type => :string
        attribute :level, :type => :integer
        attribute :currency, :type => :string
        attribute :unit, :type => :string

        def price
          if attributes[:price]
            BigDecimal(attributes[:price])
          else
            nil
          end
        end

        def price=(new_price)
          attributes[:price] = new_price.kind_of?(String) ? new_price : new_price.to_s('F')
        end

        # The base price of the resource.
        # This is the price for the base API unit which is byte for memory, data, etc. and MHz for CPU.
        # Also the price is per second for time based resource (basically everything except data transfer which is not
        # limited in time)
        def base_price
          price / multiplier
        end
      end
    end
  end
end
