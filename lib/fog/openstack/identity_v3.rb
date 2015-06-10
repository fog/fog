require 'fog/openstack/core'
require 'fog/openstack/identity'

module Fog
  module Identity
    class OpenStack
      class V3 < Fog::Service

        requires :openstack_auth_url
        recognizes :openstack_auth_token, :openstack_management_url, :persistent,
                   :openstack_service_type, :openstack_service_name, :openstack_tenant,
                   :openstack_project_name, :openstack_domain_name, :openstack_userid,
                   :openstack_api_key, :openstack_username, :openstack_current_user_id,
                   :current_user, :current_tenant,
                   :openstack_endpoint_type, :openstack_region, :openstack_domain_id,
                   :openstack_domain, :openstack_project, :provider

        model_path 'fog/openstack/models/identity_v3'
        model :domain
        collection :domains
        model :endpoint
        collection :endpoints
        model :project
        collection :projects
        model :service
        collection :services
        model :token
        collection :tokens
        model :user
        collection :users
        model :group
        collection :groups
        model :role
        collection :roles
        model :role_assignment
        collection :role_assignments
        model :os_credential
        collection :os_credentials
        model :policy
        collection :policies

        request_path 'fog/openstack/requests/identity_v3'


        request :list_users
        request :get_user
        request :create_user
        request :update_user
        request :delete_user
        request :list_user_groups
        request :list_user_projects
        request :list_groups
        request :get_group
        request :create_group
        request :update_group
        request :delete_group
        request :add_user_to_group
        request :remove_user_from_group
        request :group_user_check
        request :list_group_users
        request :list_roles
        request :list_role_assignments
        request :get_role
        request :create_role
        request :update_role
        request :delete_role
        request :auth_domains
        request :auth_projects
        request :list_domains
        request :get_domain
        request :create_domain
        request :update_domain
        request :delete_domain
        request :list_domain_user_roles
        request :grant_domain_user_role
        request :check_domain_user_role
        request :revoke_domain_user_role
        request :list_domain_group_roles
        request :grant_domain_group_role
        request :check_domain_group_role
        request :revoke_domain_group_role
        request :list_endpoints
        request :get_endpoint
        request :create_endpoint
        request :update_endpoint
        request :delete_endpoint
        request :list_projects
        request :get_project
        request :create_project
        request :update_project
        request :delete_project
        request :list_project_user_roles
        request :grant_project_user_role
        request :check_project_user_role
        request :revoke_project_user_role
        request :list_project_group_roles
        request :grant_project_group_role
        request :check_project_group_role
        request :revoke_project_group_role
        request :list_services
        request :get_service
        request :create_service
        request :update_service
        request :delete_service
        request :token_authenticate
        request :token_validate
        request :token_check
        request :token_revoke
        request :list_os_credentials
        request :get_os_credential
        request :create_os_credential
        request :update_os_credential
        request :delete_os_credential
        request :list_policies
        request :get_policy
        request :create_policy
        request :update_policy
        request :delete_policy

        class Mock
          def initialize(options={})

          end
        end

        def self.get_api_version uri, connection_options={}
          connection = Fog::Core::Connection.new(uri, false, connection_options)
          response = connection.request({
                                            :expects => [200],
                                            :headers => {'Content-Type' => 'application/json',
                                                         'Accept' => 'application/json'},
                                            :method => 'GET'
                                        })

          body = Fog::JSON.decode(response.body)
          version = nil
          unless body['version'].empty?
            version = body['version']['id']
          end
          if version.nil?
            raise Fog::OpenStack::Errors::ServiceUnavailable.new(
                      "No version available at #{uri}")
          end

          version
        end

        class Real
          attr_reader :current_user
          attr_reader :current_tenant
          attr_reader :unscoped_token
          attr_reader :auth_token

          include Fog::Identity::OpenStack::Common

          def initialize(options={})
            @openstack_auth_token = options[:openstack_auth_token]

            @openstack_region = options[:openstack_region]

            unless @openstack_auth_token
              missing_credentials = Array.new
              @openstack_api_key = options[:openstack_api_key]
              @openstack_username = options[:openstack_username]
              @openstack_userid = options[:openstack_userid]

              missing_credentials << :openstack_api_key unless @openstack_api_key
              unless @openstack_username || @openstack_userid
                missing_credentials << 'openstack_username or openstack_userid'
              end
              raise ArgumentError, "Missing required arguments: #{missing_credentials.join(', ')}" unless missing_credentials.empty?
            end

            @openstack_domain_name = options[:openstack_domain_name]
            @openstack_domain_id = options[:openstack_domain_id]
            @openstack_project_name = options[:openstack_project_name]

            @openstack_tenant = options[:openstack_tenant]
            @openstack_auth_uri = URI.parse(options[:openstack_auth_url])
            @openstack_management_url = options[:openstack_management_url]
            @openstack_must_reauthenticate = false
            @openstack_service_type = options[:openstack_service_type] || ['identity_v3','identityv3','identity']
            @openstack_service_name = options[:openstack_service_name]

            @connection_options = options[:connection_options] || {}

            @openstack_current_user_id = options[:openstack_current_user_id]

            @openstack_endpoint_type = options[:openstack_endpoint_type] || 'adminURL'

            @current_user = options[:current_user]
            @current_tenant = options[:current_tenant]

            authenticate

            @persistent = options[:persistent] || false
            @connection = Fog::Core::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
          end

          def credentials
            {:provider => 'openstack',
             :openstack_auth_url => @openstack_auth_uri.to_s,
             :openstack_auth_token => @auth_token,
             :openstack_management_url => @openstack_management_url,
             :openstack_current_user_id => @openstack_current_user_id,
             :current_user => @current_user,
             :current_tenant => @current_tenant}
          end

          def reload
            @connection.reset
          end

          def request(params)
            retried = false
            begin
              response = @connection.request(params.merge({
                                                              :headers => {
                                                                  'Content-Type' => 'application/json',
                                                                  'Accept' => 'application/json',
                                                                  'X-Auth-Token' => @auth_token
                                                              }.merge!(params[:headers] || {}),
                                                              :path => "#{@path}/#{params[:path]}" #,
                                                          }))
            rescue Excon::Errors::Unauthorized => error
              raise if retried
              retried = true

              @openstack_must_reauthenticate = true
              authenticate
              retry
            rescue Excon::Errors::HTTPStatusError => error
              raise case error
                      when Excon::Errors::NotFound
                        Fog::Identity::OpenStack::NotFound.slurp(error)
                      else
                        error
                    end
            end
            unless response.body.empty?
              response.body = Fog::JSON.decode(response.body)
            end
            response
          end


        end

      end
    end
  end
end