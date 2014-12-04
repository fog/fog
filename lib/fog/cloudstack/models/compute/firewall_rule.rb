module Fog
  module Compute
    class Cloudstack
      class FirewallRule < Fog::Model
        identity  :id,                    :aliases => 'id'
        attribute :cidr_list,             :aliases => 'cidrlist'
        attribute :start_port,            :aliases => 'startport', :type => :integer
        attribute :end_port,              :aliases => 'endport', :type => :integer
        attribute :icmp_code,             :aliases => 'icmpcode'
        attribute :icmp_type,             :aliases => 'icmptype'
        attribute :ip_address,            :aliases => 'ipaddress'
        attribute :ip_address_id,         :aliases => 'ipaddressid'
        attribute :network_id,            :aliases => 'networkid'
        attribute :protocol
        attribute :state
        attribute :tags,                  :type => :array

        # def save
        # end

      end
    end
  end
end
