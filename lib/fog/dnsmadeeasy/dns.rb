require File.expand_path(File.join(File.dirname(__FILE__), '..', 'dnsmadeeasy'))
require 'fog/dns'

module Fog
  module DNS
    class DNSMadeEasy < Fog::Service

      requires :dnsmadeeasy_api_key, :dnsmadeeasy_secret_key
      recognizes :host, :path, :port, :scheme, :persistent

      model_path 'fog/dnsmadeeasy/models/dns'
      model       :record
      collection  :records
      model       :zone
      collection  :zones

      request_path 'fog/dnsmadeeasy/requests/dns'
      request :list_domains
      request :get_domain
      request :create_domain
      request :delete_domain
      request :delete_all_domains

      request :list_records
      request :create_record
      request :update_record
      request :get_record
      request :delete_record

      request :list_secondary
      request :delete_all_secondary
      request :get_secondary
      request :create_secondary
      request :update_secondary
      request :delete_secondary

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @dnsmadeeasy_api_key = options[:dnsmadeeasy_api_key]
          @dnsmadeeasy_secret_key = options[:dnsmadeeasy_secret_key]
        end

        def data
          self.class.data[@dnsmadeeasy_api_key]
        end

        def reset_data
          self.class.data.delete(@dnsmadeeasy_api_key)
        end
      end

      class Real

        # Initialize connection to DNS Made Easy
        #
        # ==== Notes
        # options parameter must include values for :dnsmadeeasy_api_key and
        # :dnsmadeeasy_secret_key in order to create a connection
        #
        # ==== Examples
        #   dns = Fog::DNSMadeEasy::DNS.new(
        #     :dnsmadeeasy_api_key => your_dnsmadeeasy_api_key,
        #     :dnsmadeeasy_secret_key => your_dnsmadeeasy_secret_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * dns object with connection to aws.
        def initialize(options={})
          require 'fog/core/parser'
          require 'multi_json'

          @dnsmadeeasy_api_key = options[:dnsmadeeasy_api_key]
          @dnsmadeeasy_secret_key = options[:dnsmadeeasy_secret_key]
          @connection_options = options[:connection_options] || {}
          @host       = options[:host]        || 'api.dnsmadeeasy.com'
          @persistent = options[:persistent]  || true
          @port       = options[:port]        || 80 #443 Not yet
          @scheme     = options[:scheme]      || 'http' #'https Not yet
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        private

        def request(params)
          params[:headers] ||= {}
          params[:headers]['x-dnsme-apiKey'] = @dnsmadeeasy_api_key
          params[:headers]['x-dnsme-requestDate'] = Fog::Time.now.to_date_header
          params[:headers]['x-dnsme-hmac'] = signature(params)
          params[:headers]['Accept'] = 'application/json'
          params[:headers]['Content-Type'] = 'application/json'

          begin
            response = @connection.request(params)

          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::DNS::DNSMadeEasy::NotFound.slurp(error)
            else
              error
            end
          end

          unless response.body.empty?
            response.body = MultiJson.decode(response.body)
          end

          response

        end

        def signature(params)
          string_to_sign = params[:headers]['x-dnsme-requestDate']
          signed_string = OpenSSL::HMAC.hexdigest('sha1', @dnsmadeeasy_secret_key, string_to_sign)
        end
      end
    end
  end
end
