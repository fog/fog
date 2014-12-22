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
        attribute :zone_id,               :aliases => 'zone_id'
        attribute :domain_id,             :aliases => 'domain_id'
        attribute :tags,                  :type => :array
        attribute :type

       def save
          requires :display_text, :name

          options = {
            'displaytext' => display_text,
            'name'        => name,
            'customized'  => is_customized,
            'disksize'    => disk_size,
            'domain_id'   => domain_id,
            'storagetype' => storage_type,
            'tags'        => tags
          }

          response = service.associate_ip_address(options)
          merge_attributes(response['associateipaddressresponse'])
        end

        def destroy
          requires :id

          response = service.disassociate_ip_address('id' => id )
          success_status = response['disassociateipaddressresponse']['success']

          success_status == 'true'
        end

      end
    end
  end
end
