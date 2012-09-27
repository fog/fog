require 'fog/ecloud/models/compute/server'

module Fog
  module Compute
    class Ecloud
      class Servers < Fog::Ecloud::Collection
        
        model Fog::Compute::Ecloud::Server

        identity :href

        def all
          data = connection.get_servers(href).body
          if data.keys.include?(:VirtualMachines)
            data = data[:VirtualMachines][:VirtualMachine]
          elsif data[:VirtualMachine]
            data = data[:VirtualMachine]
          else
            data = []
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

        def from_data(data)
          new(data)
        end

        def create( template_uri, options )
          options[:cpus] ||= 1
          options[:memory] ||= 512
          options[:description] ||= ""
          options[:tags] ||= []
          if template_uri =~ /\/templates\/\d+/
            options[:uri] = href + "/action/createVirtualMachine"
            options[:customization] ||= :linux
            options[:powered_on] ||= false
            if options[:ips]
              options[:ips] = options[:ips].is_a?(String) ? [options[:ips]] : options[:ips]
            else
              options[:network_uri] = options[:network_uri].is_a?(String) ? [options[:network_uri]] : options[:network_uri]
              options[:network_uri].each do |uri|
                index = options[:network_uri].index(uri)
                ip = Fog::Compute::Ecloud::IpAddresses.new(:connection => connection, :href => uri).detect { |i| i.host == nil }.name
                options[:ips] ||= []
                options[:ips][index] = ip
              end
            end
            data = connection.virtual_machine_create_from_template( template_uri, options ).body
          else
            options[:uri] = href + "/action/importVirtualMachine"
            data = connection.virtual_machine_import( template_uri, options ).body
          end
          object = new(data)
          object
        end

      end
    end
  end
end

