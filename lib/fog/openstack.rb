require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

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
            data = MultiJson.decode(error.response.body)
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

    service(:compute,         'openstack/compute',        'Compute')

    # legacy v1.0 style auth
    def self.authenticate_v1(options, connection_options = {})
      openstack_auth_url = options[:openstack_auth_url]
      uri = URI.parse(openstack_auth_url)
      connection = Fog::Connection.new(openstack_auth_url, false, connection_options)
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
        :server_management_url => response.headers['X-Server-Management-Url'] 
      } 

    end

   # keystone style auth
   def self.authenticate_v2(options, connection_options = {})
      openstack_auth_url = options[:openstack_auth_url]
      uri = URI.parse(openstack_auth_url)
      connection = Fog::Connection.new(openstack_auth_url, false, connection_options)
      @openstack_api_key  = options[:openstack_api_key]
      @openstack_username = options[:openstack_username]
      @openstack_tenant = options[:openstack_tenant]
      @compute_service_name = options[:openstack_compute_service_name]

      req_body= {
        'passwordCredentials'  => {
          'username' => @openstack_username,
          'password' => @openstack_api_key
        }
      }
      req_body['tenantId'] = @openstack_tenant if @openstack_tenant

      response = connection.request({
        :expects  => [200, 204],
        :headers => {'Content-Type' => 'application/json'},
        :body  => MultiJson.encode(req_body),
        :host     => uri.host,
        :method   => 'POST',
        :path     =>  (uri.path and not uri.path.empty?) ? uri.path : 'v2.0'
      })
      body=MultiJson.decode(response.body)
     
      if body['auth']['serviceCatalog'] and body['auth']['serviceCatalog'][@compute_service_name] and body['auth']['serviceCatalog'][@compute_service_name][0] then
        mgmt_url = body['auth']['serviceCatalog'][@compute_service_name][0]['publicURL']
        token = body['auth']['token']['id']
        return {
          :token => token,
          :server_management_url => mgmt_url
        } 
      else
        raise "Unable to parse service catalog."
      end
 
    end

  end
end
