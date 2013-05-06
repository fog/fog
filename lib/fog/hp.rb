require 'fog/core'

module Fog
  module HP

    # define a specific version for the HP Provider
    unless const_defined?(:VERSION)
      VERSION = '0.0.20'
    end

    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error
        attr_reader :response_data

        def self.slurp(error)
          if error.response.body.empty?
            data = nil
            message = nil
          else
            begin
              data = Fog::JSON.decode(error.response.body)
              message = data['message']
              if message.nil? and !data.values.first.nil?
                message = data.values.first['message']
              end
            rescue MultiJson::DecodeError
              message = error.response.body  #### body is not in JSON format, so just return as is
            end
          end

          new_error = super(error, message)
          new_error.instance_variable_set(:@response_data, data)
          new_error
        end
      end

      class InternalServerError < ServiceError; end
      class Conflict < ServiceError; end
      class NotFound < ServiceError; end
      class Forbidden < ServiceError; end
      class ServiceUnavailable < ServiceError; end

      class BadRequest < ServiceError
        attr_reader :validation_errors

        def self.slurp(error)
          new_error = super(error)
          unless new_error.response_data.nil? or new_error.response_data['badRequest'].nil?
            new_error.instance_variable_set(:@validation_errors, new_error.response_data['badRequest']['validationErrors'])
          end
          new_error
        end
      end
    end

    service(:cdn,     'hp/cdn',     'CDN')
    service(:compute, 'hp/compute', 'Compute')
    service(:storage, 'hp/storage', 'Storage')
    service(:block_storage, 'hp/block_storage', 'BlockStorage')

    # legacy swauth 1.0/1.1 style authentication
    def self.authenticate_v1(options, connection_options = {})
      hp_auth_uri = options[:hp_auth_uri] || "https://region-a.geo-1.objects.hpcloudsvc.com/auth/v1.0/"
      endpoint = URI.parse(hp_auth_uri)
      @scheme = endpoint.scheme || "http"
      @host = endpoint.host || "region-a.geo-1.objects.hpcloudsvc.com"
      @port = endpoint.port.to_s || "80"
      if (endpoint.path)
        @auth_path = endpoint.path.slice(1, endpoint.path.length)  # remove the leading slash
      else
        @auth_path = "auth/v1.0"
      end
      service_url = "#{@scheme}://#{@host}:#{@port}"
      # Set the User-Agent
      @user_agent = options[:user_agent]
      set_user_agent_header(connection_options, "fog/#{Fog::VERSION}", @user_agent)
      connection = Fog::Connection.new(service_url, false, connection_options)
      @hp_access_key = options[:hp_access_key]
      @hp_secret_key  = options[:hp_secret_key]
      response = connection.request({
        :expects  => [200, 204],
        :headers  => {
          'X-Auth-Key'  => @hp_secret_key,
          'X-Auth-User' => @hp_access_key
        },
        :host     => @host,
        :port     => @port,
        :method   => 'GET',
        :path     => @auth_path
      })
      response.headers.reject do |key, value|
        !['X-Server-Management-Url', 'X-Storage-Url', 'X-CDN-Management-Url', 'X-Auth-Token'].include?(key)
      end

      return {
        :auth_token => response.headers['X-Auth-Token'],
        :endpoint_url => nil,
        :cdn_endpoint_url => response.headers['X-Storage-Url']
      }
    end

    # keystone based control services style authentication
    def self.authenticate_v2(options, connection_options = {})
      hp_auth_uri = options[:hp_auth_uri] || "https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/tokens"
      # append /tokens if missing from auth uri
      @hp_auth_uri = hp_auth_uri.include?('tokens')? hp_auth_uri : hp_auth_uri + "tokens"
      endpoint = URI.parse(@hp_auth_uri)
      @scheme = endpoint.scheme || "https"
      @host = endpoint.host || "region-a.geo-1.identity.hpcloudsvc.com"
      @port = endpoint.port.to_s || "35357"
      if (endpoint.path)
        @auth_path = endpoint.path.slice(1, endpoint.path.length)  # remove the leading slash
      else
        @auth_path = "v2.0/tokens"
      end
      service_url = "#{@scheme}://#{@host}:#{@port}"
      # Set the User-Agent. If the caller sets a user_agent, use it.
      @user_agent = options[:user_agent]
      set_user_agent_header(connection_options, "fog/#{Fog::VERSION}", @user_agent)
      connection = Fog::Connection.new(service_url, false, connection_options)

      ### Implement HP Control Services Authentication services ###
      # Get the style of auth credentials passed, defaults to access/secret key style
      @hp_use_upass_auth_style = options[:hp_use_upass_auth_style] || false
      @hp_access_key = options[:hp_access_key]
      @hp_secret_key = options[:hp_secret_key]
      @hp_tenant_id  = options[:hp_tenant_id]
      @hp_service_type  = options[:hp_service_type]
      @hp_avl_zone   = options[:hp_avl_zone]

      ### Decide which auth style to use
      unless (@hp_use_upass_auth_style)
        # If Access Key style credentials are provided, use that
        request_body = {
            'auth' => {
                'apiAccessKeyCredentials' => {
                    'accessKey' => "#{@hp_access_key}",
                    'secretKey' => "#{@hp_secret_key}"
                }
            }
        }
      else
        # Otherwise use the Username/Password style
        request_body = {
            'auth' => {
                'passwordCredentials' => {
                    'username' => "#{@hp_access_key}",
                    'password' => "#{@hp_secret_key}"
                }
            }
        }
      end
      # add tenant_id if specified
      request_body['auth']['tenantId'] = @hp_tenant_id if @hp_tenant_id

      ### Make the call to CS to get auth token and service catalog
      response = connection.request(
        {
          :expects => 200,
          :headers => {
              'Content-Type' => 'application/json'
          },
          :host => @host,
          :port => @port,
          :method => 'POST',
          :body => Fog::JSON.encode(request_body),
          :path => @auth_path
        }
      )

      body = Fog::JSON.decode(response.body)

      ### fish out auth_token and endpoint for the service
      auth_token = body['access']['token']['id']
      endpoint_url = get_endpoint_from_catalog(body['access']['serviceCatalog'], @hp_service_type, @hp_avl_zone)
      # If service is Storage, then get the CDN endpoint as well. 'Name' is unique instead of 'Type'
      if @hp_service_type == "Object Storage"
        cdn_endpoint_url = get_endpoint_from_catalog(body['access']['serviceCatalog'], "CDN", @hp_avl_zone)
      end

      return {
        :auth_token => auth_token,
        :endpoint_url => endpoint_url,
        :cdn_endpoint_url => cdn_endpoint_url
      }

    end

    # CGI.escape, but without special treatment on spaces
    def self.escape(str,extra_exclude_chars = '')
      str.gsub(/([^a-zA-Z0-9_.-#{extra_exclude_chars}]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end

    private

    def self.get_endpoint_from_catalog(service_catalog, service_type, avl_zone)
      raise "Unable to parse service catalog." unless service_catalog
      service_item = service_catalog.detect do |s|
        # 'Name' is unique instead of 'Type'
        s["name"] == service_type
      end
      if service_item and service_item['endpoints']
        endpoint = service_item['endpoints'].detect do |ep|
          ep['region'] == avl_zone
        end
        endpoint_url = endpoint['publicURL'] if endpoint
        raise "Unable to retrieve endpoint service url for availability zone '#{avl_zone}' from service catalog. " if endpoint_url.nil?
        return endpoint_url
      end
    end

    def self.set_user_agent_header(conn_opts, base_str, client_str)
      if client_str
        user_agent = {'User-Agent' => base_str + " (#{client_str})"}
      else
        user_agent = {'User-Agent' => base_str}
      end
      if conn_opts[:headers]
        conn_opts[:headers] = user_agent.merge!(conn_opts[:headers])
      else
        conn_opts[:headers] = user_agent
      end
    end

    class Mock
      def self.etag
        Fog::Mock.random_hex(32)
      end

      def self.key_fingerprint
        fingerprint = []
        20.times do
          fingerprint << Fog::Mock.random_hex(2)
        end
        fingerprint.join(':')
      end

      def self.key_material
        private_key = OpenSSL::PKey::RSA.generate(1024)
        public_key = private_key.public_key
        return private_key.to_s, public_key.to_s
      end

      def self.user_id
        "dev_" + Fog::Mock.random_numbers(14)
      end

      def self.instance_id
        Fog::Mock.random_numbers(6)
      end

      def self.ip_address
        ip = []
        4.times do
          ip << Fog::Mock.random_numbers(rand(3) + 1).to_i.to_s # remove leading 0
        end
        ip.join('.')
      end

    end

  end
end
