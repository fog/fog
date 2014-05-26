require 'fog/cloudsigma/nested_model'
require 'fog/core/collection'
require 'fog/cloudsigma/models/rule'

module Fog
  module Compute
    class CloudSigma
      class FWPolicy < Fog::CloudSigma::CloudsigmaModel
        identity :uuid
        attribute :name, :type => :string
        attribute :meta
        attribute :owner
        attribute :resource_uri, :type => :string
        attribute :servers, :type => :array
        model_attribute_array :rules, Rule
      end
    end
  end
end
