module Fog
  module Compute
    class Cloudstack
      class EgressFirewallRule < Fog::Model
        identity  :id,                    :aliases => 'id'
        attribute :protocol,              :aliases => 'protocol'
        attribute :network_id,            :aliases => 'networkid'
        attribute :state,                 :aliases => 'state'
        attribute :cidr_list,             :aliases => 'cidrlist'
        attribute :tags,                  :type => :array

      end
    end
  end
end
