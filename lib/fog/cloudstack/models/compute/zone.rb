module Fog
  module Compute
    class Cloudstack
      class Zone < Fog::Model
        identity  :id,                          :aliases => 'id'
        attribute :name
        attribute :domain_id,                   :aliases => 'domainid'
        attribute :domain_name,                 :aliases => ['domainname', 'domain']
        attribute :network_type,                :aliases => 'networktype'
        attribute :security_groups_enabled,     :aliases => ['securitygroupsenabled', 'securitygroupenabled']
        attribute :allocation_state,            :aliases => 'allocationstate'
        attribute :zone_token,                  :aliases => 'zonetoken'
        attribute :dhcp_provider,               :aliases => 'dhcpprovider'

        attr_accessor :dns1, :dns2, :internaldns1, :internaldns2, :guest_cidr_address

        def save
          options = {
            'dns1'                  => dns1,
            'internaldns1'          => internaldns1,
            'name'                  => name,
            'networktype'           => network_type,
            'allocationstate'       => allocation_state,
            'dns2'                  => dns2,
            'domain'                => domain_name,
            'domainid'              => domain_id,
            'guestcidraddress'      => guest_cidr_address,
            'internaldns2'          => internaldns2,
            'securitygroupenabled'  => security_groups_enabled,
          }
          data = service.create_zone(options)
          merge_attributes(data['createzoneresponse'])
        end

      end # Zone
    end # Cloudstack
  end # Compute
end # Fog
