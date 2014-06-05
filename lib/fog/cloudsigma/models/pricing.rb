require 'fog/cloudsigma/nested_model'
require 'fog/cloudsigma/models/price_record'

module Fog
  module Compute
    class CloudSigma
      class Pricing < Fog::CloudSigma::CloudsigmaModel
        model_attribute :cpu, PriceRecord
        model_attribute :hdd, PriceRecord
        model_attribute :ip, PriceRecord
        model_attribute :mem, PriceRecord
        model_attribute :sms, PriceRecord
        model_attribute :ssd, PriceRecord
        model_attribute :tx, PriceRecord
        model_attribute :vlan, PriceRecord
      end
    end
  end
end
