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
          show_exception_body_error {
            response = service.put_vm_network(id, attributes)
            task = response.body
            task[:id] = task[:href].split('/').last
            attributes[:network_task] = service.tasks.new(task)
          }
        end
        
        def show_exception_body_error
          yield
        rescue => @e
          raise @e unless @e.class.to_s =~ /^Excon::Errors/
          puts @e.response.status
          puts CGI::unescapeHTML(@e.response.body)
          raise @e
        end
        
        
      end
    end
  end
end