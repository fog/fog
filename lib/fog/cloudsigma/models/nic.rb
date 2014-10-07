require 'fog/core/model'
require 'fog/cloudsigma/nested_model'
require 'fog/cloudsigma/models/ipconf'

module Fog
  module Compute
    class CloudSigma
      class Nic < Fog::CloudSigma::CloudsigmaModel
        attribute :boot_order
        attribute :mac, :type => :string
        attribute :model, :type => :string
        attribute :vlan
        attribute :firewall_policy
        model_attribute :ip_v4_conf, IPConf
        model_attribute :ip_v6_conf, IPConf
      end
    end
  end
end
