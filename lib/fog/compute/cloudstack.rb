require 'json'

module Fog
  module Compute
    class Cloudstack < Fog::Service

      class BadRequest < Fog::Errors::Error; end

      requires :cloudstack_api_key, :cloudstack_secret_access_key, :host
      recognizes :host, :port, :path, :scheme, :persistent
      
      request_path 'fog/compute/requests/cloudstack'
      
      request :authorize_security_group_ingress
      
      request :create_account
      request :create_domain
      request :create_security_group
      request :create_snapshot
      request :create_user

      request :delete_account
      request :delete_domain
      request :delete_security_group
      request :delete_snapshot
      request :delete_user
      
      request :deploy_virtual_machine
      
      request :destroy_virtual_machine
      
      request :disable_user

      request :enable_user

      request :generate_usage_records
      
      request :get_vm_password
      
      request :list_accounts
      request :list_alerts
      request :list_async_jobs
      request :list_capacity
      request :list_capabilities
      request :list_clusters
      request :list_configurations
      request :list_disk_offerings
      request :list_capacity
      request :list_domains
      request :list_domain_children
      request :list_events
      request :list_external_firewalls
      request :list_external_load_balancers
      request :list_hosts
      request :list_hypervisors
      request :list_instance_groups
      request :list_isos
      request :list_network_offerings
      request :list_networks
      request :list_os_categories
      request :list_os_types
      request :list_pods
      request :list_resource_limits
      request :list_security_groups
      request :list_service_offerings
      request :list_snapshots
      request :list_ssh_key_pairs
      request :list_storage_pools
      request :list_templates
      request :list_usage_records
      request :list_users
      request :list_virtual_machines
      request :list_volumes
      request :list_zones
      
      request :query_async_job_result
      
      request :reboot_virtual_machine
      request :register_user_keys

      request :revoke_security_group_ingress
      
      request :start_virtual_machine      
      request :stop_virtual_machine
      
      request :update_account
      request :update_domain
      request :update_user
      request :update_virtual_machine
      
      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @cloudstack_api_key = options[:cloudstack_api_key]
        end

        def data
          self.class.data[@cloudstack_api_key]
        end

        def reset_data
          self.class.data.delete(@cloudstack_api_key)
        end

      end

      class Real

        def initialize(options={})
          @cloudstack_api_key         = options[:cloudstack_api_key]
          @cloudstack_secret_access_key = options[:cloudstack_secret_access_key]
          @host                       = options[:host]
          @path                       = options[:path]    || '/client/api'
          @port                       = options[:port]    || 443
          @scheme                     = options[:scheme]  || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", options[:persistent])
        end

        def reload
          @connection.reset
        end

        def request(params)
          params.merge!({
            'apiKey' => @cloudstack_api_key,
            'response' => 'json'
          })
 
          signature = Fog::Cloudstack.signed_params(@cloudstack_secret_access_key,params)
          
          params.merge!({'signature' => signature})
          
          begin
            response = @connection.request({
              :query => params,
              :method => 'GET',
              :expects => 200  
            })
          rescue Excon::Errors::HTTPStatusError => error
            error_response = JSON.parse(error.response.body)
            
            error_code = error_response.values.first['errorcode']
            error_text = error_response.values.first['errortext']
            
            case error_code
            when 431
              raise Fog::Compute::Cloudstack::BadRequest.new(error_text)
            else
              raise Fog::Compute::Cloudstack::Error.new(error_text)
            end
          end
          
          unless response.body.empty?
            response = JSON.parse(response.body)
          end
          
          response
        end

      end
    end
  end
end
