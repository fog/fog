require 'fog/core'
require 'fog/json'

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

    service(:compute ,      'Compute')
    service(:image,         'Image')
    service(:identity,      'Identity')
    service(:network,       'Network')
    service(:storage,       'Storage')
    service(:volume,        'Volume')
    service(:metering,      'Metering')
    service(:orchestration, 'Orchestration')
    service(:baremetal,     'Baremetal')
    service(:planning,      'Planning')

    def self.authenticate(options, connection_options = {})
      case options[:openstack_auth_uri].path
      when /v1(\.\d+)?/
        authenticate_v1(options, connection_options)
      when /v2(\.\d+)?/
        authenticate_v2(options, connection_options)
      when /v3(\.\d+)?/
        authenticate_v3(options, connection_options)
      else
        authenticate_v2(options, connection_options)
      end
    end

    # legacy v1.0 style auth
    def self.authenticate_v1(options, connection_options = {})
      uri = options[:openstack_auth_uri]
      connection = Fog::Core::Connection.new(uri.to_s, false, connection_options)
      @openstack_api_key  = options[:openstack_api_key]
      @openstack_username = options[:openstack_username]

      response = connection.request({
        :expects  => [200, 204],
        :headers  => {
          'X-Auth-Key'  => @openstack_api_key,
          'X-Auth-User' => @openstack_username
        },
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
      service = get_service(body, service_type, service_name)

      options[:unscoped_token] = body['access']['token']['id']

      unless service
        unless tenant_name
          response = Fog::Core::Connection.new(
            "#{uri.scheme}://#{uri.host}:#{uri.port}/v2.0/tenants", false, connection_options).request({
            :expects => [200, 204],
            :headers => {'Content-Type' => 'application/json',
                         'Accept' => 'application/json',
                         'X-Auth-Token' => body['access']['token']['id']},
            :method  => 'GET'
          })

          body = Fog::JSON.decode(response.body)
          if body['tenants'].empty?
            raise Fog::Errors::NotFound.new('No Tenant Found')
          else
            options[:openstack_tenant] = body['tenants'].first['name']
          end
        end

        body = retrieve_tokens_v2(options, connection_options)
        service = get_service(body, service_type, service_name)

      end

      service['endpoints'] = service['endpoints'].select do |endpoint|
        endpoint['region'] == openstack_region
      end if openstack_region

      if service['endpoints'].empty?
        raise Fog::Errors::NotFound.new("No endpoints available for region '#{openstack_region}'")
      end if openstack_region

      unless service
        available = body['access']['serviceCatalog'].map { |endpoint|
          endpoint['type']
        }.sort.join ', '

        missing = service_type.join ', '

        message = "Could not find service #{missing}.  Have #{available}"

        raise Fog::Errors::NotFound, message
      end

      if service['endpoints'].count > 1
        regions = service["endpoints"].map{ |e| e['region'] }.uniq.join(',')
        raise Fog::Errors::NotFound.new("Multiple regions available choose one of these '#{regions}'")
      end

      identity_service = get_service(body, identity_service_type) if identity_service_type
      tenant = body['access']['token']['tenant']
      user = body['access']['user']

      management_url = service['endpoints'].find{|s| s[endpoint_type]}[endpoint_type]
      identity_url   = identity_service['endpoints'].find{|s| s['publicURL']}['publicURL'] if identity_service

      {
        :user                     => user,
        :tenant                   => tenant,
        :identity_public_endpoint => identity_url,
        :server_management_url    => management_url,
        :token                    => body['access']['token']['id'],
        :expires                  => body['access']['token']['expires'],
        :current_user_id          => body['access']['user']['id'],
        :unscoped_token           => options[:unscoped_token]
      }
    end

    # Keystone Style Auth
    def self.authenticate_v3(options, connection_options = {})
      uri                   = options[:openstack_auth_uri]
      tenant_name           = options[:openstack_tenant]
      service_type          = options[:openstack_service_type]
      service_name          = options[:openstack_service_name]
      identity_service_type = options[:openstack_identity_service_type]
      endpoint_type         = (options[:openstack_endpoint_type] || 'public').to_s
      openstack_region      = options[:openstack_region]
      domain_name           = options[:openstack_domain]

      body, token_headers = retrieve_tokens_v3(options, connection_options)

      service = get_service(body, service_type, service_name)

      options[:unscoped_token] = token_headers['X-Subject-Token']

      unless service
        unless tenant_name
          response = Fog::Core::Connection.new(
            "#{uri.scheme}://#{uri.host}:#{uri.port}/v3/projects", false, connection_options).request({
            :expects => [200, 204],
            :headers => {'Content-Type' => 'application/json',
                         'Accept' => 'application/json',
                         'X-Auth-Token' => token_headers['X-Subject-Token']},
            :method  => 'GET'
          })
          body = Fog::JSON.decode(response.body)
          if body['projects'].empty?
            raise Fog::Errors::NotFound.new('No Tenant Found')
          else
            options[:openstack_tenant] = body['projects'].first['name']
          end

        end
        body, token_headers = retrieve_tokens_v3(options, connection_options)
        service = get_service(body, service_type, service_name)
      end

      service['endpoints'] = service['endpoints'].select do |endpoint|
        endpoint['region'] == openstack_region
      end if openstack_region

      if service['endpoints'].empty?
        raise Fog::Errors::NotFound.new("No endpoints available for region '#{openstack_region}'")
      end if openstack_region

      unless service
        available = body['token']['catalog'].map { |endpoint|
          endpoint['type']
        }.sort.join ', '

        missing = service_type.join ', '

        message = "Could not find service #{missing}.  Have #{available}"

        raise Fog::Errors::NotFound, message
      end

      admin = false
      body['token']['roles'].each do |r|
        admin = true if r["name"] == "admin"
      end

      if service['endpoints'].count > 1 and not admin
        regions = service["endpoints"].map{ |e| e['region'] }.uniq.join(',')
        raise Fog::Errors::NotFound.new("Multiple regions available choose one of these '#{regions}'")
      end

      identity_service = get_service(body, identity_service_type) if identity_service_type
      tenant = body['token']['project']['name']
      user = body['token']['user']['name']
      endpoint_type = 'public'

      management_url = service['endpoints'].find{|s| s["interface"][endpoint_type]}["url"]
      identity_url   = identity_service['endpoints'].find{|s| s["interface"]["public"]}["url"] if identity_service
      {
        :user                     => user,
        :tenant                   => tenant,
        :identity_public_endpoint => identity_url,
        :server_management_url    => management_url,
        :token                    => token_headers['X-Subject-Token'],
        :expires                  => body['token']['expires_at'],
        :current_user_id          => body['token']['user']['id'],
        :unscoped_token           => options[:unscoped_token]
      }
    end


    def self.get_service(body, service_type=[], service_name=nil)
      if not body['access'].nil?
        body['access']['serviceCatalog'].find do |s|
          if service_name.nil? or service_name.empty?
            service_type.include?(s['type'])
          else
            service_type.include?(s['type']) and s['name'] == service_name
          end
        end
      elsif not body['token']['catalog'].nil?
        body['token']['catalog'].find do |s|
          if service_name.nil? or service_name.empty?
            service_type.include?(s['type'])
          else
            service_type.include?(s['type']) and s['name'] == service_name
          end
        end

      end
    end

    def self.retrieve_tokens_v2(options, connection_options = {})
      api_key     = options[:openstack_api_key].to_s
      username    = options[:openstack_username].to_s
      tenant_name = options[:openstack_tenant].to_s
      auth_token  = options[:openstack_auth_token] || options[:unscoped_token]
      uri         = options[:openstack_auth_uri]

      connection = Fog::Core::Connection.new(uri.to_s, false, connection_options)
      request_body = {:auth => Hash.new}

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
      request_body[:auth][:tenantName] = tenant_name if tenant_name

      response = connection.request({
        :expects  => [200, 204],
        :headers  => {'Content-Type' => 'application/json'},
        :body     => Fog::JSON.encode(request_body),
        :method   => 'POST',
        :path     => (uri.path and not uri.path.empty?) ? uri.path : 'v2.0'
      })

      Fog::JSON.decode(response.body)
    end

    def self.retrieve_tokens_v3(options, connection_options = {})
      api_key     = options[:openstack_api_key].to_s
      username    = options[:openstack_username].to_s
      tenant_name = options[:openstack_tenant].to_s
      auth_token  = options[:openstack_auth_token] || options[:unscoped_token]
      uri         = options[:openstack_auth_uri]
      domain      = options[:openstack_domain]

      connection = Fog::Core::Connection.new(uri.to_s, false, connection_options)
      request_body = {:auth => Hash.new}

      if auth_token
        request_body[:auth][:token] = {
          :id => auth_token
        }
      else
        request_body[:auth][:identity] = {
          :methods => ["password"],
          :password => {
            :user => {
              :domain => {
                :name => domain
              },
              :name => username,
              :password => api_key
            }
          }
        }
        request_body[:auth][:scope] = {
          :project => {
            :domain => {
              :name => domain
            },
            :id => tenant_name
          }
        }
      end

      response = connection.request({
        :expects  => [201],
        :headers  => {'Content-Type' => 'application/json'},
        :body     => Fog::JSON.encode(request_body),
        :method   => 'POST',
        :path     => (uri.path and not uri.path.empty?) ? uri.path : 'v3'
      })

      return Fog::JSON.decode(response.body), response.headers
    end

    def self.get_supported_version(supported_versions, uri, auth_token, connection_options = {})
      connection = Fog::Core::Connection.new("#{uri.scheme}://#{uri.host}:#{uri.port}", false, connection_options)
      response = connection.request({
        :expects => [200, 204, 300],
        :headers => {'Content-Type' => 'application/json',
                     'Accept' => 'application/json',
                     'X-Auth-Token' => auth_token},
        :method  => 'GET'
      })

      body = Fog::JSON.decode(response.body)
      version = nil
      unless body['versions'].empty?
        supported_version = body['versions'].find do |x|
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
