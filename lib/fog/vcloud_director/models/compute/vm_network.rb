require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector
      class VmNetwork < Model
        identity  :id

        attribute :type
        attribute :href
        attribute :info
        attribute :primary_network_connection_index
        attribute :network
        attribute :needs_customization
        attribute :network_connection_index
        attribute :is_connected
        attribute :mac_address
        attribute :ip_address_allocation_mode

        def save
          response = service.put_network_connection_system_section_vapp(id, attributes)
          service.process_task(response.body)
        end
      end
    end
  end
end
