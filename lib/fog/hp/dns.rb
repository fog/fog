require 'fog/hp/core'

module Fog
  module HP
    class DNS < Fog::Service
      requires   :hp_access_key, :hp_secret_key, :hp_tenant_id, :hp_avl_zone
      recognizes :hp_auth_uri, :credentials, :hp_service_type
      recognizes :persistent, :connection_options
      recognizes :hp_use_upass_auth_style, :hp_auth_version, :user_agent

      secrets :hp_secret_key

      model_path 'fog/hp/models/dns'
      model      :domain
      collection :domains
      model      :record
      collection :records

      request_path 'fog/hp/requests/dns'
      request :create_domain
      request :create_record
      request :delete_domain
      request :delete_record
      request :get_domain
      request :get_record
      request :get_servers_hosting_domain
      request :list_domains
      request :list_records_in_a_domain
      request :update_domain
      request :update_record

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :domains => {},
              :records => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @hp_access_key = options[:hp_access_key]
        end

        def data
          self.class.data[@hp_access_key]
        end

        def reset_data
          self.class.data.delete(@hp_access_key)
        end
      end

      class Real
        attr_reader :credentials

        def initialize(options={})
          @hp_access_key = options[:hp_access_key]
          @hp_secret_key      = options[:hp_secret_key]
          @hp_auth_uri        = options[:hp_auth_uri]
          @connection_options = options[:connection_options] || {}
          ### Set an option to use the style of authentication desired; :v1 or :v2 (default)
          auth_version        = options[:hp_auth_version] || :v2
          ### Pass the service name for object storage to the authentication call
          options[:hp_service_type] ||= "hpext:dns"
          @hp_tenant_id       = options[:hp_tenant_id]
          @hp_avl_zone        = options[:hp_avl_zone]

          ### Make the authentication call
          if (auth_version == :v2)
            # Call the control services authentication
            credentials = Fog::HP.authenticate_v2(options, @connection_options)
            # the CS service catalog returns the block storage endpoint
            @hp_block_uri = credentials[:endpoint_url]
            @credentials = credentials
          else
            # Call the legacy v1.0/v1.1 authentication
            credentials = Fog::HP.authenticate_v1(options, @connection_options)
            # the user sends in the block storage endpoint
            @hp_block_uri = options[:hp_auth_uri]
          end

          @auth_token = credentials[:auth_token]
          @persistent = options[:persistent] || false

          uri     = URI.parse(@hp_block_uri)
          @host   = uri.host
          @path   = uri.path
          @port   = uri.port
          @scheme = uri.scheme

          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params, parse_json = true, &block)
          begin
            response = @connection.request(params.merge!({
             :headers => {
                 'Content-Type' => 'application/json',
                 'Accept'       => 'application/json',
                 'X-Auth-Token' => @auth_token
             }.merge!(params[:headers] || {}),
             :path    => "#{@path}/#{params[:path]}",
            }), &block)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
                    when Excon::Errors::NotFound
                      Fog::HP::DNS::NotFound.slurp(error)
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
