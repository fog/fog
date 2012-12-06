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

      class InternalServerError < ServiceError; end
      class Conflict < ServiceError; end
      class NotFound < ServiceError; end
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
    service(:identity, 'openstack/identity', 'Identity')
    service(:network, 'openstack/network', 'Network')

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
        :server_management_url => response.headers['X-Server-Management-Url'],
        :identity_public_endpoint => response.headers['X-Keystone']
      }
    end

    # Keystone Style Auth
    def self.authenticate_v2(options, connection_options = {})
      uri                   = options[:openstack_auth_uri]
      tenant_name           = options[:openstack_tenant]
      service_name          = options[:openstack_service_name]
      identity_service_name = options[:openstack_identity_service_name]
      endpoint_type         = (options[:openstack_endpoint_type] || 'publicURL').to_s
      openstack_region      = options[:openstack_region]


      body = retrieve_tokens_v2(options, connection_options)
      service = body['access']['serviceCatalog'].
        detect {|s| service_name.include?(s['type']) }

      options[:unscoped_token] = body['access']['token']['id']

      unless service
        unless tenant_name
          response = Fog::Connection.new(
            "#{uri.scheme}://#{uri.host}:#{uri.port}/v2.0/tenants", false, connection_options).request({
            :expects => [200, 204],
            :headers => {'Content-Type' => 'application/json',
                         'Accept' => 'application/json',
                         'X-Auth-Token' => body['access']['token']['id']},
            :host    => uri.host,
            :method  => 'GET'
          })

          body = Fog::JSON.decode(response.body)
          if body['tenants'].empty?
            raise Errors::NotFound.new('No Tenant Found')
          else
            options[:openstack_tenant] = body['tenants'].first['name']
          end
        end

        body = retrieve_tokens_v2(options, connection_options)
        service = body['access']['serviceCatalog'].
          detect{|s| service_name.include?(s['type']) }
      end

      service['endpoints'] = service['endpoints'].select do |endpoint|
        endpoint['region'] == openstack_region
      end if openstack_region

      unless service
        available = body['access']['serviceCatalog'].map { |endpoint|
          endpoint['type']
        }.sort.join ', '

        missing = service_name.join ', '

        message = "Could not find service #{missing}.  Have #{available}"

        raise Errors::NotFound, message
      end

      if service['endpoints'].count > 1
        regions = service["endpoints"].map{ |e| e['region'] }.uniq.join(',')
        raise Errors::NotFound.new("Multiple regions available choose one of these '#{regions}'")
      end

      identity_service = body['access']['serviceCatalog'].
        detect{|x| identity_service_name.include?(x['type']) } if identity_service_name
      tenant = body['access']['token']['tenant']
      user = body['access']['user']

      management_url = service['endpoints'].detect{|s| s[endpoint_type]}[endpoint_type]
      identity_url   = identity_service['endpoints'].detect{|s| s['publicURL']}['publicURL'] if identity_service

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

    def self.retrieve_tokens_v2(options, connection_options = {})
      api_key     = options[:openstack_api_key].to_s
      username    = options[:openstack_username].to_s
      tenant_name = options[:openstack_tenant].to_s
      auth_token  = options[:openstack_auth_token] || options[:unscoped_token]
      uri         = options[:openstack_auth_uri]

      connection = Fog::Connection.new(uri.to_s, false, connection_options)
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
        :host     => uri.host,
        :method   => 'POST',
        :path     => (uri.path and not uri.path.empty?) ? uri.path : 'v2.0'
      })

      Fog::JSON.decode(response.body)
    end

  end
end
