require File.expand_path(File.join(File.dirname(__FILE__), '..', 'cloudstack'))
require 'fog/compute'
require 'digest/md5'

module Fog
  module Compute
    class Cloudstack < Fog::Service

      class BadRequest < Fog::Compute::Cloudstack::Error; end
      class Unauthorized < Fog::Compute::Cloudstack::Error; end

      requires :cloudstack_host
      
      recognizes :cloudstack_api_key, :cloudstack_secret_access_key, :cloudstack_session_key, :cloudstack_session_id,
                 :cloudstack_port, :cloudstack_path, :cloudstack_scheme, :cloudstack_persistent
      
      request_path 'fog/cloudstack/requests/compute'
      
      request :acquire_ip_address
      request :assign_to_load_balancer_rule
      request :attach_volume
      request :authorize_security_group_ingress
      request :change_service_for_virtual_machine
      request :create_account
      request :create_domain
      request :create_load_balancer_rule
      request :create_network
      request :create_port_forwarding_rule
      request :create_security_group
      request :create_ssh_key_pair
      request :create_snapshot
      request :create_snapshot_policy
      request :create_user
      request :create_volume
      request :delete_account
      request :delete_domain
      request :delete_load_balancer_rule
      request :delete_port_forwarding_rule
      request :delete_security_group
      request :delete_ssh_key_pair
      request :delete_snapshot
      request :delete_snapshot_policies
      request :delete_user
      request :delete_volume
      request :detach_volume
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
      request :list_load_balancer_rules
      request :list_load_balancer_rule_instances
      request :list_network_offerings
      request :list_networks
      request :list_os_categories
      request :list_os_types
      request :list_pods
      request :list_port_forwarding_rules
      request :list_public_ip_addresses
      request :list_resource_limits
      request :list_security_groups
      request :list_service_offerings
      request :list_snapshots
      request :list_snapshot_policies
      request :list_ssh_key_pairs
      request :list_storage_pools
      request :list_templates
      request :list_usage_records
      request :list_users
      request :list_virtual_machines
      request :list_volumes
      request :list_zones
      request :migrate_virtual_machine
      request :query_async_job_result
      request :reboot_virtual_machine
      request :recover_virtual_machine
      request :register_ssh_key_pair
      request :register_user_keys
      request :remove_from_load_balancer_rule
      request :reset_password_for_virtual_machine
      request :revoke_security_group_ingress
      request :start_virtual_machine      
      request :stop_virtual_machine
      request :update_account
      request :update_domain
      request :update_user
      request :update_resource_count
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
          require 'multi_json'          
          @cloudstack_api_key         = options[:cloudstack_api_key]
          @cloudstack_secret_access_key = options[:cloudstack_secret_access_key]
          @cloudstack_session_id      = options[:cloudstack_session_id]
          @cloudstack_session_key      = options[:cloudstack_session_key]
          @host                       = options[:cloudstack_host]
          @path                       = options[:cloudstack_path]    || '/client/api'
          @port                       = options[:cloudstack_port]    || 443
          @scheme                     = options[:cloudstack_scheme]  || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", options[:cloudstack_persistent], {:ssl_verify_peer => false})
        end

        def reload
          @connection.reset
        end

        def login(username,password,domain)
          response = issue_request({
            'response' => 'json',
            'command'  => 'login',
            'username' => username,
            'password' => Digest::MD5.hexdigest(password),
            'domain'   => domain
          })

          # Parse response cookies to retrive JSESSIONID token
          cookies   = CGI::Cookie.parse(response.headers['Set-Cookie'])
          sessionid = cookies['JSESSIONID'].first

          # Decode the login response
          response   = MultiJson.decode(response.body)
          
          user = response['loginresponse']
          user.merge!('sessionid' => sessionid)
          
          @cloudstack_session_id  = user['sessionid']
          @cloudstack_session_key = user['sessionkey']
  
          user
        end
        
        def request(params)
          params.reject!{|k,v| v.nil?}
          
          params.merge!('response' => 'json')
          
          if has_session?
            params, headers = authorize_session(params)
          elsif has_keys?
            params, headers = authorize_api_keys(params)
          end

          response = issue_request(params,headers)
          response = MultiJson.decode(response.body) unless response.body.empty?
          response
        end

      private
        def has_session?
          @cloudstack_session_id && @cloudstack_session_key
        end
        
        def has_keys?
          @cloudstack_api_key && @cloudstack_secret_access_key
        end
        
        def authorize_session(params)
          # set the session id cookie for the request
          headers = {'Cookie' => "JSESSIONID=#{@cloudstack_session_id};"}
          # set the sesion key for the request, params are not signed using session auth
          params.merge!('sessionkey' => @cloudstack_session_key)
          
          return params, headers
        end
        
        def authorize_api_keys(params)
          headers = {}
          # merge the api key into the params
          params.merge!('apiKey' => @cloudstack_api_key)
          # sign the request parameters
          signature = Fog::Cloudstack.signed_params(@cloudstack_secret_access_key,params)
          # merge signature into request param
          params.merge!({'signature' => signature})
          
          return params, headers
        end
        
        def issue_request(params={},headers={},method='GET',expects=200)
          begin
            response = @connection.request({
              :query => params,
              :headers => headers,
              :method => method,
              :expects => expects  
            })
            
          rescue Excon::Errors::HTTPStatusError => error
            error_response = MultiJson.decode(error.response.body)
            
            error_code = error_response.values.first['errorcode']
            error_text = error_response.values.first['errortext']
            
            case error_code
            when 401
              raise Fog::Compute::Cloudstack::Unauthorized, error_text
            when 431
              raise Fog::Compute::Cloudstack::BadRequest, error_text
            else
              raise Fog::Compute::Cloudstack::Error, error_text
            end
          end
          
        end
      end
    end
  end
end
