require 'fog/cloudsigma/nested_model'

module Fog
  module Compute
    class CloudSigma
      class IP < Fog::CloudSigma::CloudsigmaModel
        identity :uuid
        attribute :tags, :type => :array
        attribute :nameservers, :type => :array
        attribute :server, :type => :string
        attribute :netmask, :type => :integer
        attribute :meta
        attribute :owner
        attribute :subscription
        attribute :gateway, :type => :string
        attribute :resource_uri, :type => :string
      end
    end
  end
end
