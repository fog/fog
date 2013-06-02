require 'fog/cloudsigma/nested_model'
require 'fog/cloudsigma/models/subscriptions'

module Fog
  module Compute
    class CloudSigma
      class PriceCalculation < Fog::CloudSigma::CloudsigmaModel
        attribute :price, :type => :float
        model_attribute_array :subscriptions, Subscription, :aliases => 'objects'
      end
    end
  end
end
