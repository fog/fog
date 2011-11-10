require File.expand_path(File.join(File.dirname(__FILE__), '..', 'dnsimple'))
require 'fog/dns'

module Fog
  module DNS
    class DNSimple < Fog::Service

      requires :dnsimple_email, :dnsimple_password
      recognizes :dnsimple_url, :host, :path, :port, :scheme, :persistent

      model_path 'fog/dnsimple/models/dns'
      model       :record
      collection  :records
      model       :zone
      collection  :zones

      request_path 'fog/dnsimple/requests/dns'
      request :list_domains
      request :create_domain
      request :get_domain
      request :delete_domain
      request :create_record
      request :list_records
      request :update_record
      request :delete_record
      request :get_record

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
          @dnsimple_email = options[:dnsimple_email]
          @dnsimple_password  = options[:dnsimple_password]
        end

        def data
          self.class.data[@dnsimple_email]
        end

        def reset_data
          self.class.data.delete(@dnsimple_email)
        end

      end

      class Real

        def initialize(options={})
          require 'multi_json'

          @dnsimple_email = options[:dnsimple_email]
          @dnsimple_password  = options[:dnsimple_password]
          @connection_options = options[:connection_options] || {}
          if options[:dnsimple_url]
            uri = URI.parse(options[:dnsimple_url])
            options[:host]    = uri.host
            options[:port]    = uri.port
            options[:scheme]  = uri.scheme
          end
          @host       = options[:host]        || "dnsimple.com"
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:headers] ||= {}
          key = "#{@dnsimple_email}:#{@dnsimple_password}"
          params[:headers].merge!({ "Authorization" => "Basic " + Base64.encode64(key).chomp,
                                    "Accept" => "application/json",
                                    "Content-Type" => "application/json" })

          response = @connection.request(params.merge!({:host => @host}))

          unless response.body.empty?
            response.body = MultiJson.decode(response.body)
          end
          response
        end
      end
    end
  end
end
