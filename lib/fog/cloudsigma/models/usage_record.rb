require 'fog/cloudsigma/nested_model'

module Fog
  module Compute
    class CloudSigma
      class UsageRecord < Fog::CloudSigma::CloudsigmaModel
        attribute :burst, :type => :integer
        attribute :subscribed, :type => :integer
        attribute :using, :type => :integer
      end
    end
  end
end
