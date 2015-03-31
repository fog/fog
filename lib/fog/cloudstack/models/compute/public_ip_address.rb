module Fog
  module Compute
    class Cloudstack
      class PublicIpAddress < Fog::Model
        identity  :id,                    :aliases => 'id'
        attribute :network_id,            :aliases => 'networkid'
        attribute :associated_network_id, :aliases => 'associatednetworkid'
        attribute :physical_network_id,   :aliases => 'physicalnetworkid'
        attribute :ip_address,            :aliases => 'ipaddress'
        attribute :mac_address,           :aliases => 'macaddress'
        attribute :state,                 :aliases => 'state'
        attribute :traffic_type,          :aliases => 'traffictype'
        attribute :is_default,            :aliases => 'isdefault', :type => :boolean
        attribute :is_source_nat,         :aliases => 'issourcenat', :type => :boolean
        attribute :is_static_nat,         :aliases => 'isstaticnat', :type => :boolean
        attribute :is_system,             :aliases => 'issytem', :type => :boolean
        attribute :is_portable,           :aliases => 'isportable', :type => :boolean
        attribute :allocated,             :aliases => 'allocated', :type => :time
        attribute :zone_id,               :aliases => 'zoneid'
        attribute :region_id,             :aliases => 'regionid'
        attribute :vpc_id,                :aliases => 'vpcid'
        attribute :account,               :aliases => 'account'
        attribute :domain_id,             :aliases => 'domainid'
        attribute :tags,                  :type => :array
        attribute :type
        attribute :job_id,                                  :aliases => 'jobid'   # only on create

        def save

          options = {
            'account'     => account,
            'domainid'    => domain_id,
            'isportable'  => is_portable,
            'networkid'   => network_id,
            'regionid'    => region_id,
            'vpcid'       => vpc_id,
            'zoneid'      => zone_id,
          }

          response = service.associate_ip_address(options)
          merge_attributes(response['associateipaddressresponse'])
        end

        def destroy
          # requires :id

          response = service.disassociate_ip_address('id' => self.id )
          job = service.jobs.new(response['disassociateipaddressresponse'])
        end

      end
    end
  end
end
