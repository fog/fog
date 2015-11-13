require 'fog/openstack/core'

module Fog
  module Volume
    class OpenStack < Fog::Service
      requires :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url,
                 :persistent, :openstack_service_type, :openstack_service_name,
                 :openstack_tenant, :openstack_tenant_id,
                 :openstack_api_key, :openstack_username, :openstack_identity_endpoint,
                 :current_user, :current_tenant, :openstack_region,
                 :openstack_endpoint_type,
                 :openstack_project_name, :openstack_project_id,
                 :openstack_project_domain, :openstack_user_domain, :openstack_domain_name,
                 :openstack_project_domain_id, :openstack_user_domain_id, :openstack_domain_id

      model_path 'fog/openstack/models/volume'

      model       :volume
      collection  :volumes

      model       :availability_zone
      collection  :availability_zones

      model       :volume_type
      collection  :volume_types

      model       :transfer
      collection  :transfers

      request_path 'fog/openstack/requests/volume'

       # Volume
      request :list_volumes
      request :list_volumes_detailed
      request :create_volume
      request :get_volume_details
      request :extend_volume
      request :delete_volume
      request :volume_action

      request :list_zones

      request :list_volume_types
      request :create_volume_type
      request :update_volume_type
      request :delete_volume_type
      request :get_volume_type_details

      request :create_volume_snapshot
      request :list_snapshots
      request :list_snapshots_detailed
      request :get_snapshot_details
      request :delete_snapshot

      request :list_transfers
      request :list_transfers_detailed
      request :create_transfer
      request :get_transfer_details
      request :accept_transfer
      request :delete_transfer

      request :update_quota
      request :get_quota
      request :get_quota_defaults

      request :get_quota_usage

      request :set_tenant

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :users => {},
              :tenants => {},
              :quota => {
                'gigabytes' => 1000,
                'volumes'   => 10,
                'snapshots' => 10
              }
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @openstack_username = options[:openstack_username]
          @openstack_tenant   = options[:openstack_tenant]
          @openstack_auth_uri = URI.parse(options[:openstack_auth_url])

          @auth_token = Fog::Mock.random_base64(64)
          @auth_token_expiration = (Time.now.utc + 86400).iso8601

          management_url = URI.parse(options[:openstack_auth_url])
          management_url.port = 8776
          management_url.path = '/v1'
          @openstack_management_url = management_url.to_s

          @data ||= { :users => {} }
          unless @data[:users].find {|u| u['name'] == options[:openstack_username]}
            id = Fog::Mock.random_numbers(6).to_s
            @data[:users][id] = {
              'id'       => id,
              'name'     => options[:openstack_username],
              'email'    => "#{options[:openstack_username]}@mock.com",
              'tenantId' => Fog::Mock.random_numbers(6).to_s,
              'enabled'  => true
            }
          end
        end

        def data
          self.class.data[@openstack_username]
        end

        def reset_data
          self.class.data.delete(@openstack_username)
        end

        def credentials
          { :provider                 => 'openstack',
            :openstack_auth_url       => @openstack_auth_uri.to_s,
            :openstack_auth_token     => @auth_token,
            :openstack_management_url => @openstack_management_url }
        end
      end

      class Real
        include Fog::OpenStack::Core

        def initialize(options={})
          initialize_identity options

          @openstack_service_type   = options[:openstack_service_type] || ['volume']
          @openstack_service_name   = options[:openstack_service_name]
          @openstack_endpoint_type  = options[:openstack_endpoint_type] || 'adminURL'

          @connection_options       = options[:connection_options] || {}

          authenticate

          @persistent                       = options[:persistent] || false
          @connection = Fog::Core::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def request(params)
          begin
            response = @connection.request(params.merge({
              :headers  => {
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :path     => "#{@path}/#{params[:path]}"#,
            }))
          rescue Excon::Errors::Unauthorized => error
            if error.response.body != 'Bad username or password' # token expiration
              @openstack_must_reauthenticate = true
              authenticate
              retry
            else # bad credentials
              raise error
            end
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::OpenStack::NotFound.slurp(error)
            else
              error
            end
          end
          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

        private

      end
    end
  end
end
