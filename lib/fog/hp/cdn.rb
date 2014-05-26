require 'fog/hp/core'
require 'fog/cdn'

module Fog
  module CDN
    class HP < Fog::Service
      requires    :hp_secret_key, :hp_tenant_id, :hp_avl_zone
      recognizes  :hp_auth_uri, :hp_cdn_uri, :credentials, :hp_service_type
      recognizes  :hp_use_upass_auth_style, :hp_auth_version, :user_agent
      recognizes  :persistent, :connection_options
      recognizes  :hp_access_key, :hp_account_id  # :hp_account_id is deprecated use hp_access_key instead

      secrets     :hp_secret_key

      model_path   'fog/hp/models/cdn'

      request_path 'fog/hp/requests/cdn'
      request :get_containers
      request :head_container
      request :post_container
      request :put_container
      request :delete_container

      module Utils
      end

      class Mock
        include Utils

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :cdn_containers => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          # deprecate hp_account_id
          if options[:hp_account_id]
            Fog::Logger.deprecation(":hp_account_id is deprecated, please use :hp_access_key instead.")
            @hp_access_key = options.delete(:hp_account_id)
          end
          @hp_access_key = options[:hp_access_key]
          unless @hp_access_key
            raise ArgumentError.new("Missing required arguments: hp_access_key. :hp_account_id is deprecated, please use :hp_access_key instead.")
          end
        end

        def data
          self.class.data[@hp_access_key]
        end

        def reset_data
          self.class.data.delete(@hp_access_key)
        end
      end

      class Real
        include Utils
        attr_reader :credentials

        def initialize(options={})
          # deprecate hp_account_id
          if options[:hp_account_id]
            Fog::Logger.deprecation(":hp_account_id is deprecated, please use :hp_access_key instead.")
            options[:hp_access_key] = options.delete(:hp_account_id)
          end
          @hp_access_key = options[:hp_access_key]
          unless @hp_access_key
            raise ArgumentError.new("Missing required arguments: hp_access_key. :hp_account_id is deprecated, please use :hp_access_key instead.")
          end
          @hp_secret_key = options[:hp_secret_key]
          @connection_options = options[:connection_options] || {}
          ### Set an option to use the style of authentication desired; :v1 or :v2 (default)
          ### A symbol is required, we should ensure that the value is loaded as a symbol
          auth_version = options[:hp_auth_version] || :v2
          auth_version = auth_version.to_s.downcase.to_sym

          ### Pass the service name for object storage to the authentication call
          options[:hp_service_type] ||= "CDN"
          @hp_tenant_id = options[:hp_tenant_id]

          ### Make the authentication call
          if (auth_version == :v2)
            # Call the control services authentication
            credentials = Fog::HP.authenticate_v2(options, @connection_options)
            ### When using the v2 CS authentication, the CDN Mgmt comes from the service catalog
            @hp_cdn_uri = credentials[:endpoint_url]
            cdn_mgmt_url = @hp_cdn_uri
            @credentials = credentials
          else
            # Call the legacy v1.0/v1.1 authentication
            credentials = Fog::HP.authenticate_v1(options, @connection_options)
            # In case of legacy authentication systems, the user can pass the CDN Mgmt Uri
            @hp_cdn_uri = options[:hp_cdn_uri] || "https://region-a.geo-1.cdnmgmt.hpcloudsvc.com/v1.0"
            # In case of legacy authentication systems, the :cdn_endpoint_url will carry the cdn storage url
            cdn_mgmt_url = "#{@hp_cdn_uri}#{URI.parse(credentials[:cdn_endpoint_url]).path}"
          end

          @auth_token = credentials[:auth_token]
          @enabled = false
          @persistent = options[:persistent] || false

          if cdn_mgmt_url
            uri = URI.parse(cdn_mgmt_url)
            @host   = uri.host
            @path   = uri.path.chomp("/")
            @port   = uri.port
            @scheme = uri.scheme
            @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
            @enabled = true
          end
        end

        def enabled?
          @enabled
        end

        def reload
          @cdn_connection.reset
        end

        def request(params, parse_json = true, &block)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'Accept'       => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :path     => "#{@path}/#{params[:path]}",
            }), &block)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::CDN::HP::NotFound.slurp(error)
            else
              error
            end
          end
          if !response.body.empty? && parse_json && response.headers['Content-Type'] =~ %r{application/json}
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end
      end
    end
  end
end
