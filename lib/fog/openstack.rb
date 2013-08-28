require 'fog/core'

module Fog
  module OpenStack
    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error
        attr_reader :response_data

        def self.slurp(error)
          if error.response.body.empty?
            data = nil
            message = nil
          else
            data = Fog::JSON.decode(error.response.body)
            message = data['message']
            if message.nil? and !data.values.first.nil?
              message = data.values.first['message']
            end
          end

          new_error = super(error, message)
          new_error.instance_variable_set(:@response_data, data)
          new_error
        end
      end

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

    service(:compute , 'openstack/compute' , 'Compute' )
    service(:image, 'openstack/image', 'Image')
    service(:identity, 'openstack/identity', 'Identity')
    service(:network, 'openstack/network', 'Network')
    service(:storage, 'openstack/storage', 'Storage')
    service(:volume,  'openstack/volume',  'Volume')
    service(:metering,  'openstack/metering',  'Metering')

    def self.authenticate(options, connection_options = {})
      case options[:openstack_auth_uri].path
      when /v1(\.\d+)?/
        authenticate_v1(options, connection_options)
      else
        authenticate_v2(options, connection_options)
      end
    end

    # legacy v1.0 style auth
    def self.authenticate_v1(options, connection_options = {})
      uri = options[:openstack_auth_uri]
      connection = Fog::Connection.new(uri.to_s, false, connection_options)
      @openstack_api_key  = options[:openstack_api_key]
      @openstack_username = options[:openstack_username]

      response = connection.request({
        :expects  => [200, 204],
        :headers  => {
          'X-Auth-Key'  => @openstack_api_key,
          'X-Auth-User' => @openstack_username
        },
        :host     => uri.host,
        :method   => 'GET',
        :path     =>  (uri.path and not uri.path.empty?) ? uri.path : 'v1.0'
      })

      return {
        :token => response.headers['X-Auth-Token'],
        :server_management_url => response.headers['X-Server-Management-Url'] || response.headers['X-Storage-Url'],
        :identity_public_endpoint => response.headers['X-Keystone']
      }
    end

    # Keystone Style Auth
    def self.authenticate_v2(options, connection_options = {})
      uri                   = options[:openstack_auth_uri]
      tenant_name           = options[:openstack_tenant]
      service_type          = options[:openstack_service_type]
      service_name          = options[:openstack_service_name]
      identity_service_type = options[:openstack_identity_service_type]
      endpoint_type         = (options[:openstack_endpoint_type] || 'publicURL').to_s
      openstack_region      = options[:openstack_region]


      body = retrieve_tokens_v2(options, connection_options)

      if tenant_name
        service = get_service(body, service_type, service_name)
      else
        options[:unscoped_token] = body['access']['token']['id']
        response = Fog::Connection.new(
          "#{uri.scheme}://#{uri.host}:#{uri.port}/v2.0/tenants", false, connection_options).request({
          :expects => [200, 204],
          :headers => { 'Content-Type' => 'application/json',
                        'Accept' => 'application/json',
                        'X-Auth-Token' => options[:unscoped_token] },
          :host    => uri.host,
          :method  => 'GET'
        })

        tenants = Fog::JSON.decode(response.body)['tenants']
        if tenants.empty?
          raise Fog::Errors::NotFound, 'No Tenant Found'
        elsif tenants.count > 1
          available = tenants.map {|t| t['name'] }.join(', ')
          raise Fog::Errors::NotFound, "Multiple tenants found. Choose one of '#{ available }'."
        end

        options[:openstack_tenant] = tenants.first['name']
        body = retrieve_tokens_v2(options, connection_options)
        service = get_service(body, service_type, service_name)
      end

      unless service
        available = body['access']['serviceCatalog'].map {|s| s['type'] }.join(', ')
        missing = service_type.join(', ')
        raise Fog::Errors::NotFound, "Could not find service(s) '#{ missing }' in '#{ available }'."
      end

      if openstack_region
        service['endpoints'] = service['endpoints'].select do |endpoint|
          endpoint['region'] == openstack_region
        end
        raise Fog::Errors::NotFound,
          "No endpoints available for region '#{openstack_region}'" if service['endpoints'].empty?
      end

      if service['endpoints'].count > 1
        regions = service["endpoints"].map{ |e| e['region'] }.uniq.join(',')
        raise Fog::Errors::NotFound.new("Multiple regions available choose one of these '#{regions}'")
      end

      tenant = body['access']['token']['tenant']
      user = body['access']['user']
      management_url = service['endpoints'].detect{|s| s[endpoint_type]}[endpoint_type]

      if identity_service = get_service(body, identity_service_type)
        identity_url = identity_service['endpoints'].detect{|s| s['publicURL']}['publicURL']
      end if identity_service_type

      {
        :user                     => user,
        :tenant                   => tenant,
        :identity_public_endpoint => identity_url,
        :server_management_url    => management_url,
        :token                    => body['access']['token']['id'],
        :expires                  => body['access']['token']['expires'],
        :current_user_id          => body['access']['user']['id']
      }

    end

    def self.get_service(body, service_type=[], service_name=nil)
      services = body['access']['serviceCatalog'].select {|s|
        if service_name.to_s.empty?
          service_type.include?(s['type'])
        else
          service_type.include?(s['type']) && s['name'] == service_name
        end
      }
      if services.count > 1
        available = services.map {|s| s['type'] + '|' + s['name'] }.join(', ')
        raise Fog::Errors::NotFound, "Multiple matching services found.\n" +
            "Provide #openstack_service_type and/or #openstack_service_name\n" +
            "to uniquely identify one of these services (type|name) '#{ available }'"
      end
      services.first
    end

    def self.retrieve_tokens_v2(options, connection_options = {})
      api_key     = options[:openstack_api_key].to_s
      username    = options[:openstack_username].to_s
      tenant_name = options[:openstack_tenant].to_s
      auth_token  = options[:openstack_auth_token] || options[:unscoped_token]
      uri         = options[:openstack_auth_uri]

      connection = Fog::Connection.new(uri.to_s, false, connection_options)
      request_body = {:auth => {:tenantName => tenant_name}}

      if auth_token
        request_body[:auth][:token] = {
          :id => auth_token
        }
      else
        request_body[:auth][:passwordCredentials] = {
          :username => username,
          :password => api_key
        }
      end

      response = connection.request({
        :expects  => [200, 204],
        :headers  => {'Content-Type' => 'application/json',
                      'Accept' => 'application/json'},
        :body     => Fog::JSON.encode(request_body),
        :method   => 'POST',
        :path     => uri.path.chomp('/').empty? ? 'v2.0/tokens' : uri.path
      })

      Fog::JSON.decode(response.body)
    end

    def self.get_supported_version(supported_versions, uri, auth_token, connection_options = {})
      connection = Fog::Connection.new("#{uri.scheme}://#{uri.host}:#{uri.port}", false, connection_options)
      response = connection.request({
        :expects => [200, 204, 300],
        :headers => {'Content-Type' => 'application/json',
                     'Accept' => 'application/json',
                     'X-Auth-Token' => auth_token},
        :host    => uri.host,
        :method  => 'GET'
      })

      body = Fog::JSON.decode(response.body)
      version = nil
      unless body['versions'].empty?
        supported_version = body['versions'].detect do |x|
          x["id"].match(supported_versions) &&
          (x["status"] == "CURRENT" || x["status"] == "SUPPORTED")
        end
        version = supported_version["id"] if supported_version
      end
      if version.nil?
        raise Fog::OpenStack::Errors::ServiceUnavailable.new(
                  "OpenStack service only supports API versions #{supported_versions.inspect}")
      end

      version
    end

    # CGI.escape, but without special treatment on spaces
    def self.escape(str,extra_exclude_chars = '')
      str.gsub(/([^a-zA-Z0-9_.-#{extra_exclude_chars}]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end

  end
end
