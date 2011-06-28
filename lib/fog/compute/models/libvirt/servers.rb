require 'fog/core/collection'
require 'fog/compute/models/libvirt/server'

module Fog
  module Compute
    class Libvirt

      class Servers < Fog::Collection

        model Fog::Compute::Libvirt::Server

        def all 
          
          data = connection.list_defined_domains.map do |machine|
            {
              :raw => connection.lookup_domain_by_name(machine)
            }
          end

          connection.list_domains.each do |machine|
            data << {
              :raw => connection.lookup_domain_by_id(machine)
            }
          end
          load(data)
        end

        def bootstrap(new_attributes = {})
          raise 'Not Implemented'
          # server = create(new_attributes)
          # server.start
          # server.wait_for { ready? }
          # server.setup(:password => server.password)
          # server
        end

        # Retrieve the server by uuid
        def get(server_id)
          machine=connection.lookup_domain_by_uuid(server_id)          
          new(:raw => machine)
        end

        # Retrieve the server by name
        def get_by_name(name)
          machine=connection.lookup_domain_by_name(name)                    
          new(:raw => machine)
        end

      end #class
    end #Class
  end #module
end #Module
