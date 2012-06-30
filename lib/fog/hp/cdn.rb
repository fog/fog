require 'fog/hp'
require 'fog/cdn'

module Fog
  module CDN
    class HP < Fog::Service

      requires    :hp_secret_key, :hp_account_id, :hp_tenant_id
      recognizes  :hp_auth_uri, :hp_cdn_uri, :persistent, :connection_options, :hp_use_upass_auth_style, :hp_auth_version

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
          @hp_account_id = options[:hp_account_id]
        end

        def data
          self.class.data[@hp_account_id]
        end

        def reset_data
          self.class.data.delete(@hp_account_id)
        end

      end

      class Real
        include Utils

        def initialize(options={})
          @connection_options = options[:connection_options] || {}
          ### Set an option to use the style of authentication desired; :v1 or :v2 (default)
          auth_version = options[:hp_auth_version] || :v2
          ### Pass the service type for object storage to the authentication call
          options[:hp_service_type] = "hpext:cdn"

          ### Make the authentication call
          if (auth_version == :v2)
            # Call the control services authentication
            credentials = Fog::HP.authenticate_v2(options, @connection_options)
            ### When using the v2 CS authentication, the CDN Mgmt comes from the service catalog
            @hp_cdn_uri = credentials[:endpoint_url]
            cdn_mgmt_url = @hp_cdn_uri
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
            @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
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
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
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
