require 'fog/rackspace/core'

module Fog
  module DNS
    class Rackspace < Fog::Service
      include Fog::Rackspace::Errors

      class ServiceError < Fog::Rackspace::Errors::ServiceError; end
      class InternalServerError < Fog::Rackspace::Errors::InternalServerError; end
      class BadRequest < Fog::Rackspace::Errors::BadRequest; end
      class Conflict < Fog::Rackspace::Errors::Conflict; end
      class ServiceUnavailable < Fog::Rackspace::Errors::ServiceUnavailable; end

      class CallbackError < Fog::Errors::Error
        attr_reader :response, :message, :details
        def initialize(response)
          @response = response
          @message = response.body['error']['message']
          @details = response.body['error']['details']
        end
      end

      US_ENDPOINT = 'https://dns.api.rackspacecloud.com/v1.0'
      UK_ENDPOINT = 'https://lon.dns.api.rackspacecloud.com/v1.0'

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :rackspace_auth_token, :rackspace_dns_endpoint, :rackspace_dns_url, :rackspace_region

      model_path 'fog/rackspace/models/dns'
      model       :record
      collection  :records
      model       :zone
      collection  :zones

      request_path 'fog/rackspace/requests/dns'
      #TODO - Import/Export, modify multiple domains, modify multiple records
      request :callback
      request :list_domains
      request :list_domain_details
      request :modify_domain
      request :create_domains
      request :remove_domain
      request :remove_domains
      request :list_subdomains
      request :list_records
      request :list_record_details
      request :modify_record
      request :remove_record
      request :remove_records
      request :add_records

      class Mock < Fog::Rackspace::Service
        def initialize(options={})
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @connection_options = options[:connection_options] || {}
        end

        def self.data
          @data ||= {
          }
        end

        def self.reset
          @data = nil
        end

        def data
          self.class.data
        end

        def reset_data
          self.class.reset
        end
      end

      class Real < Fog::Rackspace::Service
        def service_name
          :cloudDNS
        end

        def region
          #Note: DNS does not currently support multiple regions
          @rackspace_region
        end

        def initialize(options={})
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @connection_options = options[:connection_options] || {}
          @rackspace_endpoint = Fog::Rackspace.normalize_url(options[:rackspace_dns_url] || options[:rackspace_dns_endpoint])
          @rackspace_region = options[:rackspace_region]

          authenticate

          deprecation_warnings(options)

          @persistent = options[:persistent] || false
          @connection = Fog::Core::Connection.new(endpoint_uri.to_s, @persistent, @connection_options)
        end

        def endpoint_uri(service_endpoint_url=nil)
          @uri = super(@rackspace_endpoint || service_endpoint_url, :rackspace_dns_url)
        end

        private

        def request(params, parse_json = true)
          super
        rescue Excon::Errors::NotFound => error
          raise NotFound.slurp(error, self)
        rescue Excon::Errors::BadRequest => error
          raise BadRequest.slurp(error, self)
        rescue Excon::Errors::InternalServerError => error
          raise InternalServerError.slurp(error, self)
        rescue Excon::Errors::ServiceUnavailable => error
          raise ServiceUnavailable.slurp(error, self)
        rescue Excon::Errors::Conflict => error
          raise Conflict.slurp(error, self)
        rescue Excon::Errors::HTTPStatusError => error
          raise ServiceError.slurp(error, self)
        end

        def array_to_query_string(arr)
          return "" unless arr
          query_array = arr.map do | k, v |
            val_str = v.is_a?(Array) ? v.join(",") : v.to_s
            "#{k}=#{val_str}"
          end

          query_array.join('&')
        end

        def validate_path_fragment(name, fragment)
          if fragment.nil? or fragment.to_s.empty?
            raise ArgumentError.new("#{name} cannot be null or empty")
          end
        end

        private

        def deprecation_warnings(options)
          Fog::Logger.deprecation("The :rackspace_dns_endpoint option is deprecated. Please use :rackspace_dns_url for custom endpoints") if options[:rackspace_dns_endpoint]
        end

        def setup_endpoint(credentials)
          account_id = credentials['X-Server-Management-Url'].match(/.*\/([\d]+)$/)[1]

          @uri = URI.parse(@rackspace_endpoint || US_ENDPOINT)
          @uri.path = "#{@uri.path}/#{account_id}"
        end

        def authenticate_v1(options)
          credentials = Fog::Rackspace.authenticate(options, @connection_options)
          setup_endpoint credentials
          @auth_token = credentials['X-Auth-Token']
        end

        def authenticate(options={})
          super({
            :rackspace_api_key  => @rackspace_api_key,
            :rackspace_username => @rackspace_username,
            :rackspace_auth_url => @rackspace_auth_url,
            :connection_options => @connection_options
          })
        end
      end
    end
  end
end
