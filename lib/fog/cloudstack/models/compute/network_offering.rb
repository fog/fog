module Fog
  module Compute
    class Cloudstack
      class NetworkOffering < Fog::Model
        identity  :id,                      :aliases => 'id'
        attribute :name,                    :aliases => 'name'
        attribute :display_text,            :aliases => 'displaytext'
        attribute :traffic_type,            :aliases => 'traffictype'
        attribute :is_default,              :aliases => 'isdefault', :type => :boolean
        attribute :specify_vlan,            :aliases => 'specifyvlan'
        attribute :conserve_mode,           :aliases => 'conservemode'
        attribute :specify_ip_ranges,       :aliases => 'specifyipranges'
        attribute :availability,            :aliases => 'availability'
        attribute :network_rate,            :aliases => 'networkrate'
        attribute :state,                   :aliases => 'state'
        attribute :guest_ip_type,           :aliases => 'guestiptype'
        attribute :service_offering_id,     :aliases => 'serviceofferingid'
        attribute :service,                 :aliases => 'service'
        attribute :for_vpc,                 :aliases => 'forvpc'
        attribute :is_persistent,           :aliases => 'ispersistent', :type => :boolean
        attribute :egress_default_policy,   :aliases => 'egressdefaultpolicy'
      end # NetworkOffering
    end # Cloudstack
  end # Compute
end # Fog
