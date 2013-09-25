require 'fog/cloudsigma/nested_model'

module Fog
  module Compute
    class CloudSigma
      class IPConf < Fog::CloudSigma::CloudsigmaModel
        attribute :ip
        attribute :conf, :type => :string
      end
    end
  end
end
