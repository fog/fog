require 'fog/cloudsigma/nested_model'

module Fog
  module Compute
    class CloudSigma
      class Rule < Fog::CloudSigma::CloudsigmaModel
        attribute :action, :type => :string
        attribute :comment, :type => :string
        attribute :direction, :type => :string
        attribute :dst_ip, :type => :string
        attribute :dst_port, :type => :integer
        attribute :ip_proto, :type => :string
        attribute :src_ip, :type => :string
        attribute :src_port, :type => :string
      end
    end
  end
end
