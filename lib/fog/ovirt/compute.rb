
module Fog
  module Compute
    class Ovirt < Fog::Service

      requires   :ovirt_username, :ovirt_password
      recognizes :ovirt_url,      :ovirt_server,  :ovirt_port, :ovirt_api_path, :ovirt_datacenter

      model_path 'fog/ovirt/models/compute'
      model      :server
      collection :servers
      model      :template
      collection :templates
      model      :cluster
      collection :clusters
      model      :interface
      collection :interfaces

      request_path 'fog/ovirt/requests/compute'

      request :vm_action
      request :destroy_vm
      request :create_vm
      request :update_vm
      request :datacenters
      request :storage_domains
      request :list_virtual_machines
      request :get_virtual_machine
      request :list_templates
      request :get_template
      request :list_clusters
      request :get_cluster
      request :add_interface
      request :destroy_interface
      request :update_interface
      request :list_vm_interfaces
      request :list_template_interfaces
      request :list_networks
      request :vm_ticket

      module Shared
        # converts an OVIRT object into an hash for fog to consume.
        def ovirt_attrs obj
          opts = {:raw => obj}
          obj.instance_variables.each do |v|
            key = v.to_s.gsub("@","").to_sym
            value = obj.instance_variable_get(v)
            #ignore nil values
            next if value.nil?

            opts[key] = case value
                        when OVIRT::Link
                          value.id
                        when Array
                          value
                        when Hash
                          value
                        else
                          value.to_s.strip
                        end
          end
          opts
        end
      end

      class Mock
        include Shared

        def initialize(options={})
          require 'rbovirt'
          username = options[:ovirt_username]
          password = options[:ovirt_password]
          url      = options[:ovirt_url]
        end

        private
        attr_reader :client
        #read mocks xml
        def read_xml(file_name)
          file_path = File.join(File.dirname(__FILE__),"requests","compute","mock_files",file_name)
          File.read(file_path)
        end
      end

      class Real
        include Shared


        def initialize(options={})
          require 'rbovirt'
          username   = options[:ovirt_username]
          password   = options[:ovirt_password]
          server     = options[:ovirt_server]
          port       = options[:ovirt_port]       || 8080
          api_path   = options[:ovirt_api_path]   || '/api'
          url        = options[:ovirt_url]        || "#{@scheme}://#{server}:#{port}#{api_path}"
          datacenter = options[:ovirt_datacenter]

          @client = OVIRT::Client.new(username, password, url, datacenter)
        end

        private
        attr_reader :client
      end
    end
  end
end
