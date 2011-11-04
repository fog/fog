require File.expand_path(File.join(File.dirname(__FILE__), '..', 'rackspace'))
require 'fog/dns'

module Fog
  module DNS
    class Rackspace < Fog::Service

      US_ENDPOINT = 'https://dns.api.rackspacecloud.com/v1.0'
      UK_ENDPOINT = 'https://lon.dns.api.rackspacecloud.com/v1.0'

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url
      recognizes :rackspace_auth_token

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

      class Mock

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

      class Real
        def initialize(options={})
          require 'multi_json'
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @connection_options = options[:connection_options] || {}
          uri = URI.parse(options[:rackspace_dns_endpoint] || US_ENDPOINT)

          @auth_token, @account_id = *authenticate
          @persistent = options[:persistent] || false
          @path       = "#{uri.path}/#{@account_id}"

          @connection_options[:headers] ||= {}
          @connection_options[:headers].merge!({ 'Content-Type' => 'application/json', 'X-Auth-Token' => @auth_token })

          @connection = Fog::Connection.new(uri.to_s, @persistent, @connection_options)
        end

        private

        def request(params)
          #TODO - Unify code with other rackspace services
          begin
            response = @connection.request(params.merge!({
              :path     => "#{@path}/#{params[:path]}"
            }))
          rescue Excon::Errors::BadRequest => error
            raise Fog::Rackspace::Errors::BadRequest.slurp error
          rescue Excon::Errors::Conflict => error
            raise Fog::Rackspace::Errors::Conflict.slurp error
          rescue Excon::Errors::NotFound => error
            raise Fog::Rackspace::Errors::NotFound.slurp error
          rescue Excon::Errors::ServiceUnavailable => error
            raise Fog::Rackspace::Errors::ServiceUnavailable.slurp error
          end
          unless response.body.empty?
            response.body = MultiJson.decode(response.body)
          end
          response
        end

        def authenticate
          options = {
            :rackspace_api_key  => @rackspace_api_key,
            :rackspace_username => @rackspace_username,
            :rackspace_auth_url => @rackspace_auth_url
          }
          credentials = Fog::Rackspace.authenticate(options, @connection_options)
          auth_token = credentials['X-Auth-Token']
          account_id = credentials['X-Server-Management-Url'].match(/.*\/([\d]+)$/)[1]
          [auth_token, account_id]
        end

        def array_to_query_string(arr)
          arr.collect {|k,v| "#{k}=#{v}" }.join('&')
        end

        def validate_path_fragment(name, fragment)
          if fragment.nil? or fragment.to_s.empty?
            raise ArgumentError.new("#{name} cannot be null or empty")
          end
        end
      end
    end
  end
end
