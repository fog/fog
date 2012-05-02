require 'fog/ecloudv2/models/compute/server'

module Fog
  module Compute
    class Ecloudv2
      class Servers < Fog::Ecloudv2::Collection
        
        model Fog::Compute::Ecloudv2::Server

        identity :href

        def all
          data = connection.get_servers(href).body
          if data.keys.include?(:VirtualMachines)
            data = data[:VirtualMachines][:VirtualMachine]
          else
            data = data[:VirtualMachine]
          end
          load(data)
        end

        def get(uri)
          if data = connection.get_server(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end

