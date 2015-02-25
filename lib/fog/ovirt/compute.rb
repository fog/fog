require 'fog/ovirt/core'

module Fog
  module Compute
    class Ovirt < Fog::Service
      requires   :ovirt_username, :ovirt_password
      recognizes :ovirt_url,      :ovirt_server,  :ovirt_port, :ovirt_api_path, :ovirt_datacenter,
                 :ovirt_filtered_api,
                 :ovirt_ca_cert_store, :ovirt_ca_cert_file, :ovirt_ca_no_verify

      model_path 'fog/ovirt/models/compute'
      model      :server
      collection :servers
      model      :template
      collection :templates
      model      :cluster
      collection :clusters
      model      :interface
      collection :interfaces
      model      :volume
      collection :volumes
      model      :quota
      collection :quotas
      model      :affinity_group
      collection :affinity_groups

      request_path 'fog/ovirt/requests/compute'

      request :vm_action
      request :vm_start_with_cloudinit
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
      request :list_vm_volumes
      request :list_template_volumes
      request :list_volumes
      request :add_volume
      request :destroy_volume
      request :update_volume
      request :attach_volume
      request :detach_volume
      request :get_api_version
      request :list_quotas
      request :get_quota
      request :list_affinity_groups
      request :get_affinity_group
      request :list_affinity_group_vms
      request :create_affinity_group
      request :destroy_affinity_group
      request :add_to_affinity_group
      request :remove_from_affinity_group

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
                        when OVIRT::TemplateVersion
                          value
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
        end

        private

        def client
          return @client if defined?(@client)
        end

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

          connection_opts = {}
          connection_opts[:datacenter_id] = options[:ovirt_datacenter]
          connection_opts[:ca_cert_store] = options[:ovirt_ca_cert_store]
          connection_opts[:ca_cert_file]  = options[:ovirt_ca_cert_file]
          connection_opts[:ca_no_verify]  = options[:ovirt_ca_no_verify]
          connection_opts[:filtered_api]  = options[:ovirt_filtered_api]

          @client = OVIRT::Client.new(username, password, url, connection_opts)
        end

        def api_version
          client.api_version
        end

        private

        def client
          @client
        end
      end
    end
  end
end
