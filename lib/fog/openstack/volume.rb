require 'fog/openstack'

module Fog
  module Volume
    class OpenStack < Fog::Service

      requires :openstack_auth_url
      recognizes :openstack_auth_token, :openstack_management_url, :persistent,
                 :openstack_service_type, :openstack_service_name, :openstack_tenant,
                 :openstack_api_key, :openstack_username,
                 :current_user, :current_tenant,
                 :openstack_endpoint_type, :openstack_region

      model_path 'fog/openstack/models/volume'

      model       :volume
      collection  :volumes

      model       :volume_type
      collection  :volume_types

      request_path 'fog/openstack/requests/volume'

       # Volume
      request :list_volumes
      request :create_volume
      request :get_volume_details
      request :delete_volume

      request :list_volume_types
      request :get_volume_type_details

      request :create_volume_snapshot
      request :list_snapshots
      request :get_snapshot_details
      request :delete_snapshot

      request :update_quota
      request :get_quota
      request :get_quota_defaults

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
        attr_reader :current_user
        attr_reader :current_tenant

        def initialize(options={})
          @openstack_auth_token = options[:openstack_auth_token]

          unless @openstack_auth_token
            missing_credentials = Array.new
            @openstack_api_key  = options[:openstack_api_key]
            @openstack_username = options[:openstack_username]

            missing_credentials << :openstack_api_key  unless @openstack_api_key
            missing_credentials << :openstack_username unless @openstack_username
            raise ArgumentError, "Missing required arguments: #{missing_credentials.join(', ')}" unless missing_credentials.empty?
          end

          @openstack_tenant               = options[:openstack_tenant]
          @openstack_auth_uri             = URI.parse(options[:openstack_auth_url])
          @openstack_management_url       = options[:openstack_management_url]
          @openstack_must_reauthenticate  = false
          @openstack_service_type         = options[:openstack_service_type] || ['volume']
          @openstack_service_name         = options[:openstack_service_name]
          @openstack_region               = options[:openstack_region]

          @openstack_endpoint_type        = options[:openstack_endpoint_type] || 'adminURL'
          @connection_options = options[:connection_options] || {}

          @current_user = options[:current_user]
          @current_tenant = options[:current_tenant]

          authenticate

          @persistent = options[:persistent] || false
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def credentials
          { :provider                 => 'openstack',
            :openstack_auth_url       => @openstack_auth_uri.to_s,
            :openstack_auth_token     => @auth_token,
            :openstack_management_url => @openstack_management_url,
            :current_user             => @current_user,
            :current_tenant           => @current_tenant }
        end

        def reload
          @connection.reset
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

        def authenticate
          if !@openstack_management_url || @openstack_must_reauthenticate
            options = {
              :openstack_region   => @openstack_region,
              :openstack_tenant   => @openstack_tenant,
              :openstack_api_key  => @openstack_api_key,
              :openstack_username => @openstack_username,
              :openstack_auth_uri => @openstack_auth_uri,
              :openstack_auth_token => @openstack_auth_token,
              :openstack_service_type => @openstack_service_type,
              :openstack_service_name => @openstack_service_name,
              :openstack_endpoint_type => @openstack_endpoint_type
            }

            credentials = Fog::OpenStack.authenticate_v2(options, @connection_options)

            @current_user = credentials[:user]
            @current_tenant = credentials[:tenant]

            @openstack_must_reauthenticate = false
            @auth_token = credentials[:token]
            @openstack_management_url = credentials[:server_management_url]
            uri = URI.parse(@openstack_management_url)
          else
            @auth_token = @openstack_auth_token
            uri = URI.parse(@openstack_management_url)
          end

          @host   = uri.host
          @path   = uri.path
          @path.sub!(/\/$/, '')
          @port   = uri.port
          @scheme = uri.scheme
          true
        end

      end
    end
  end
end

