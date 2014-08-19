require 'fog/openstack/core'

module Fog
  module Storage
    class OpenStack < Fog::Service
      requires   :auth_url, :username,
                 :api_key
      recognizes :persistent, :service_name,
                 :service_type, :tenant,
                 :region, :temp_url_key

      model_path 'fog/openstack/models/storage'
      model       :directory
      collection  :directories
      model       :file
      collection  :files

      request_path 'fog/openstack/requests/storage'
      request :copy_object
      request :delete_container
      request :delete_object
      request :delete_multiple_objects
      request :delete_static_large_object
      request :get_container
      request :get_containers
      request :get_object
      request :get_object_http_url
      request :get_object_https_url
      request :head_container
      request :head_containers
      request :head_object
      request :put_container
      request :put_object
      request :put_object_manifest
      request :put_dynamic_obj_manifest
      request :put_static_obj_manifest
      request :post_set_meta_temp_url_key

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
          @api_key = options[:api_key]
          @username = options[:username]
          @path = '/v1/AUTH_1234'
        end

        def data
          self.class.data[@username]
        end

        def reset_data
          self.class.data.delete(@username)
        end

        def change_account(account)
          @original_path ||= @path
          version_string = @original_path.split('/')[1]
          @path = "/#{version_string}/#{account}"
        end

        def reset_account_name
          @path = @original_path
        end
      end

      class Real
        def initialize(options={})
          @api_key = options[:api_key]
          @username = options[:username]
          @auth_url = options[:auth_url]
          @auth_token = options[:auth_token]
          @storage_url = options[:storage_url]
          @must_reauthenticate = false
          @service_type = options[:service_type] || ['object-store']
          @service_name = options[:service_name]
          @region       = options[:region]
          @tenant       = options[:tenant]
          @connection_options     = options[:connection_options] || {}
          @temp_url_key = options[:temp_url_key]
          authenticate
          @persistent = options[:persistent] || false
          @connection = Fog::Core::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        # Change the current account while re-using the auth token.
        #
        # This is usefull when you have an admin role and you're able
        # to HEAD other user accounts, set quotas, list files, etc.
        #
        # For example:
        #
        #     # List current user account details
        #     service = Fog::Storage[:openstack]
        #     service.request :method => 'HEAD'
        #
        # Would return something like:
        #
        #     Account:                      AUTH_1234
        #     Date:                         Tue, 05 Mar 2013 16:50:52 GMT
        #     X-Account-Bytes-Used:         0 (0.00 Bytes)
        #     X-Account-Container-Count:    0
        #     X-Account-Object-Count:       0
        #
        # Now let's change the account
        #
        #     service.change_account('AUTH_3333')
        #     service.request :method => 'HEAD'
        #
        # Would return something like:
        #
        #     Account:                      AUTH_3333
        #     Date:                         Tue, 05 Mar 2013 16:51:53 GMT
        #     X-Account-Bytes-Used:         23423433
        #     X-Account-Container-Count:    2
        #     X-Account-Object-Count:       10
        #
        # If we wan't to go back to our original admin account:
        #
        #     service.reset_account_name
        #
        def change_account(account)
          @original_path ||= @path
          version_string = @path.split('/')[1]
          @path = "/#{version_string}/#{account}"
        end

        def reset_account_name
          @path = @original_path
        end

        def request(params, parse_json = true)
          begin
            response = @connection.request(params.merge({
              :headers  => {
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :path     => "#{@path}/#{params[:path]}",
            }))
          rescue Excon::Errors::Unauthorized => error
            if error.response.body != 'Bad username or password' # token expiration
              @must_reauthenticate = true
              authenticate
              retry
            else # bad credentials
              raise error
            end
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Storage::OpenStack::NotFound.slurp(error)
            else
              error
            end
          end
          if !response.body.empty? && parse_json && response.get_header('Content-Type') =~ %r{application/json}
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

        private

        def authenticate
          if !@management_url || @must_reauthenticate
            options = {
              :api_key  => @api_key,
              :username => @username,
              :auth_uri => URI.parse(@auth_url),
              :service_type => @service_type,
              :service_name => @service_name,
              :region => @region,
              :tenant => @tenant,
              :endpoint_type => 'publicURL'
            }

            credentials = Fog::OpenStack.authenticate(options, @connection_options)

            @current_user = credentials[:user]
            @current_tenant = credentials[:tenant]

            @must_reauthenticate = false
            @auth_token = credentials[:token]
            @management_url = credentials[:server_management_url]
            uri = URI.parse(@management_url)
          else
            @auth_token = @auth_token
            uri = URI.parse(@management_url)
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
