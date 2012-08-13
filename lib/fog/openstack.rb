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
          unless new_error.response_data.nil?
            new_error.instance_variable_set(:@validation_errors, new_error.response_data['validationErrors'])
          end
          new_error
        end
      end
    end

    service(:compute , 'openstack/compute' , 'Compute' )
    service(:identity, 'openstack/identity', 'Identity')

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
      uri = options[:openstack_auth_uri]
      connection = Fog::Connection.new(uri.to_s, false, connection_options)
      @openstack_api_key  = options[:openstack_api_key]
      @openstack_username = options[:openstack_username]
      @openstack_tenant   = options[:openstack_tenant]
      @openstack_auth_token = options[:openstack_auth_token]
      @service_name         = options[:openstack_service_name]
      @identity_service_name = options[:openstack_identity_service_name]
      @endpoint_type         = options[:openstack_endpoint_type] || 'publicURL'
      @openstack_region      = options[:openstack_region]

      if @openstack_auth_token
        req_body = {
          'auth' => {
            'token' => {
              'id' => @openstack_auth_token
            }
          }
        }
      else
        req_body = {
          'auth' => {
            'passwordCredentials'  => {
              'username' => @openstack_username,
              'password' => @openstack_api_key.to_s
            }
          }
        }
      end
      req_body['auth']['tenantName'] = @openstack_tenant if @openstack_tenant

      body = retrieve_tokens_v2(connection, req_body, uri)

      svc = body['access']['serviceCatalog'].
        detect{|x| @service_name.include?(x['type']) }

      unless svc
        unless @openstack_tenant
          response = Fog::Connection.new(
            "#{uri.scheme}://#{uri.host}:#{uri.port}/v2.0/tenants", false, connection_options).request({
            :expects => [200, 204],
            :headers => {'Content-Type' => 'application/json',
                         'X-Auth-Token' => body['access']['token']['id']},
            :host    => uri.host,
            :method  => 'GET'
          })

          body = Fog::JSON.decode(response.body)
          if body['tenants'].empty?
            raise Errors::NotFound.new('No Tenant Found')
          else
            req_body['auth']['tenantName'] = body['tenants'].first['name']
          end
        end

        body = retrieve_tokens_v2(connection, req_body, uri)
        if body['access']['token']['tenant'].nil?
          raise Errors::NotFound.new("Invalid Tenant '#{@openstack_tenant}'")
        end
        svc = body['access']['serviceCatalog'].
          detect{|x| @service_name.include?(x['type']) }
      end

      svc['endpoints'] = svc['endpoints'].select{ |x| x['region'] == @openstack_region } if @openstack_region
      if svc['endpoints'].count > 1
         regions = svc["endpoints"].map { |x| x['region'] }.uniq.join(',')
         raise Errors::NotFound.new("Multiple regions available choose one of these '#{regions}'")
      end

      identity_svc = body['access']['serviceCatalog'].
        detect{|x| @identity_service_name.include?(x['type']) } if @identity_service_name
      tenant = body['access']['token']['tenant']
      user = body['access']['user']

      mgmt_url = svc['endpoints'].detect{|x| x[@endpoint_type]}[@endpoint_type]
      identity_url = identity_svc['endpoints'].detect{|x| x['publicURL']}['publicURL'] if identity_svc
      token = body['access']['token']['id']

      {
        :user                     => user,
        :tenant                   => tenant,
        :token                    => token,
        :server_management_url    => mgmt_url,
        :identity_public_endpoint => identity_url,
        :current_user_id          => body['access']['user']['id']
      }
    end

    def self.retrieve_tokens_v2(connection, request_body, uri)
      response = connection.request({
        :expects  => [200, 204],
        :headers  => {'Content-Type' => 'application/json'},
        :body     => Fog::JSON.encode(request_body),
        :host     => uri.host,
        :method   => 'POST',
        :path     =>  (uri.path and not uri.path.empty?) ? uri.path : 'v2.0'
      })

      Fog::JSON.decode(response.body)
    end

  end
end
