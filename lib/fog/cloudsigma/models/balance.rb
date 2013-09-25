require 'fog/cloudsigma/nested_model'

module Fog
  module Compute
    class CloudSigma
      class Balance < Fog::CloudSigma::CloudsigmaModel
        attribute :balance, :type => :float
        attribute :currency, :type => :string
      end
    end
  end
end
