module Fog
  module Compute
    class Cloudstack
      class Vlan < Fog::Model
        identity  :id
        attribute :start_ip,                                    :aliases => 'startip'
        attribute :end_ip,                                      :aliases => 'endip'
        attribute :netmask
        attribute :gateway
        attribute :account
        attribute :domain
        attribute :domain_id,                                   :aliases => 'domainid'
        attribute :for_virtual_network,   :type => :boolean,    :aliases => 'forvirtualnetwork'
        attribute :network_id,                                  :aliases => 'networkid'
        attribute :physical_network_id,                         :aliases => 'physicalnetworkid'
        attribute :pod_id,                                      :aliases => 'podid'
        attribute :pod_name,                                    :aliases => 'podname'
        attribute :project
        attribute :project_id,                                  :aliases => 'projectid'
        attribute :vlan
        attribute :zone_id,                                     :aliases => 'zoneid'

        def create_vlan_ip_range
          requires :start_ip, :end_ip, :netmask, :gateway, :zone_id
          options = {
              'startip'        => start_ip,
              'endip'          => end_ip,
              'netmask'        => netmask,
              'gateway'        => gateway,
              'zoneid'         => zone_id,
              'vlan'           => vlan
          }

          data = service.create_vlan_ip_range(options)
          merge_attributes(data['createvlaniprangeresponse']['vlan'])
        end

        def delete_vlan_ip_range
          requires :id
          data = service.delete_vlan_ip_range(options={'id' => self.id})
        end

        def list_vlan_ip_ranges
          requires :zone_id

          data = service.list_vlan_ip_ranges(options={'zoneid' => self.zone_id})
          merge_attributes(data['listvlaniprangesresponse'])
        end

      end
    end
  end
end