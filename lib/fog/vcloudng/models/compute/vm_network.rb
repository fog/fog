require 'fog/core/model'

module Fog
  module Compute
    class Vcloudng

      class VmNetwork < Fog::Model
        
        
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
          response = service.put_vm_network(id, attributes)
          task = response.body
          task[:id] = task[:href].split('/').last
          attributes[:network_task] = service.tasks.new(task)
        end
        
      end
    end
  end
end