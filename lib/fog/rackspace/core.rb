require 'fog/core'
require 'fog/json'
require 'fog/rackspace/mock_data'
require 'fog/rackspace/service'
require 'fog/rackspace/errors'

module Fog
  module Rackspace
    extend Fog::Provider

    US_AUTH_ENDPOINT = 'https://identity.api.rackspacecloud.com/v2.0' unless defined? US_AUTH_ENDPOINT
    UK_AUTH_ENDPOINT = 'https://lon.identity.api.rackspacecloud.com/v2.0' unless defined? UK_AUTH_ENDPOINT

    module Errors
      class ServiceError < Fog::Errors::Error
        attr_reader :response_data, :status_code, :transaction_id

        def to_s
          status = status_code ? "HTTP #{status_code}" : "HTTP <Unknown>"
          "[#{status} | #{transaction_id}] #{super}"
        end

        def self.slurp(error, service=nil)
          data = nil
          message = nil
          status_code = nil

          if error.response
            status_code = error.response.status
            unless error.response.body.empty?
              begin
                data = Fog::JSON.decode(error.response.body)
                message = extract_message(data)
              rescue  => e
                Fog::Logger.warning("Received exception '#{e}' while decoding>> #{error.response.body}")
                message = error.response.body
                data = error.response.body
              end
            end
          end

          new_error = super(error, message)
          new_error.instance_variable_set(:@response_data, data)
          new_error.instance_variable_set(:@status_code, status_code)
          new_error.set_transaction_id(error, service)
          new_error
        end

        def set_transaction_id(error, service)
          return unless service && service.respond_to?(:request_id_header) && error.response
          @transaction_id = error.response.headers[service.request_id_header]
        end

        def self.extract_message(data)
          if data.is_a?(Hash)
            message = data.values.first['message'] if data.values.first.is_a?(Hash)
            message ||= data['message']
          end
          message || data.inspect
        end
      end

      class InternalServerError < ServiceError; end
      class Conflict < ServiceError; end
      class ServiceUnavailable < ServiceError; end
      class MethodNotAllowed < ServiceError; end
      class BadRequest < ServiceError
        attr_reader :validation_errors

        def to_s
          "#{super} - #{validation_errors}"
        end

        def self.slurp(error, service=nil)
          new_error = super(error)
          unless new_error.response_data.nil? or new_error.response_data['badRequest'].nil?
            new_error.instance_variable_set(:@validation_errors, new_error.response_data['badRequest']['validationErrors'])
          end

          status_code = error.response ? error.response.status : nil
          new_error.instance_variable_set(:@status_code, status_code)
          new_error.set_transaction_id(error, service)
          new_error
        end
      end
    end

    service(:auto_scale,       'AutoScale')
    service(:block_storage,    'BlockStorage')
    service(:cdn,              'CDN')
    service(:cdn_v2,           'CDN v2')
    service(:compute,          'Compute')
    service(:compute_v2,       'Compute v2')
    service(:dns,              'DNS')
    service(:storage,          'Storage')
    service(:load_balancers,   'LoadBalancers')
    service(:identity,         'Identity')
    service(:databases,        'Databases')
    service(:monitoring,       'Monitoring')
    service(:queues,           'Queues')
    service(:networking,       'Networking')
    service(:orchestration,    'Orchestration')
    service(:networkingV2,     'NetworkingV2')

    def self.authenticate(options, connection_options = {})
      rackspace_auth_url = options[:rackspace_auth_url]
      rackspace_auth_url ||= options[:rackspace_endpoint] == Fog::Compute::RackspaceV2::LON_ENDPOINT ? UK_AUTH_ENDPOINT : US_AUTH_ENDPOINT
      url = rackspace_auth_url.match(/^https?:/) ? \
                rackspace_auth_url : 'https://' + rackspace_auth_url
      uri = URI.parse(url)
      connection = Fog::Core::Connection.new(url, false, connection_options)
      @rackspace_api_key  = options[:rackspace_api_key]
      @rackspace_username = options[:rackspace_username]
      response = connection.request({
        :expects  => [200, 204],
        :headers  => {
          'X-Auth-Key'  => @rackspace_api_key,
          'X-Auth-User' => @rackspace_username
        },
        :method   => 'GET',
        :path     =>  (uri.path and not uri.path.empty?) ? uri.path : 'v1.0'
      })
      response.headers.reject do |key, value|
        !['X-Server-Management-Url', 'X-Storage-Url', 'X-CDN-Management-Url', 'X-Auth-Token'].include?(key)
      end
    end

    def self.json_response?(response)
      return false unless response && response.headers
      response.get_header('Content-Type') =~ %r{application/json}i ? true : false
    end

    def self.normalize_url(endpoint)
      return nil unless endpoint
      str = endpoint.chomp " "
      str = str.chomp "/"
      str.downcase
    end

    # CGI.escape, but without special treatment on spaces
    def self.escape(str,extra_exclude_chars = '')
      # '-' is a special character inside a regex class so it must be first or last.
      # Add extra excludes before the final '-' so it always remains trailing, otherwise
      # an unwanted range is created by mistake.
      str.gsub(/([^a-zA-Z0-9_.#{extra_exclude_chars}-]+)/) do
        '%' + $1.unpack('H2' * $1.bytesize).join('%').upcase
      end
    end
  end
end
