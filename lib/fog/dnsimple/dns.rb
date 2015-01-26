require 'fog/dnsimple/core'

module Fog
  module DNS
    class DNSimple < Fog::Service
      recognizes :dnsimple_email, :dnsimple_password, :dnsimple_token, :dnsimple_domain, :dnsimple_url, :host, :path, :port, :scheme, :persistent

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
            hash[key] = {
              :domains => [],
              :records => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @dnsimple_email = options[:dnsimple_email]
          @dnsimple_password  = options[:dnsimple_password]
          @dnsimple_token = options[:dnsimple_token]
          @dnsimple_domain = options[:dnsimple_domain]
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
          @dnsimple_email = options[:dnsimple_email]
          @dnsimple_password  = options[:dnsimple_password]
          @dnsimple_token = options[:dnsimple_token]
          @dnsimple_domain = options[:dnsimple_domain]
          @connection_options = options[:connection_options] || {}
          if options[:dnsimple_url]
            uri = URI.parse(options[:dnsimple_url])
            options[:host]    = uri.host
            options[:port]    = uri.port
            options[:scheme]  = uri.scheme
          end
          @host       = options[:host]        || "api.dnsimple.com"
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:headers] ||= {}

          if(@dnsimple_password)
            key = "#{@dnsimple_email}:#{@dnsimple_password}"
            params[:headers].merge!("Authorization" => "Basic " + Base64.encode64(key).gsub("\n",''))
          elsif(@dnsimple_token)
            if(@dnsimple_domain)
              params[:headers].merge!("X-DNSimple-Domain-Token" => @dnsimple_token)
            else
              params[:headers].merge!("X-DNSimple-Token" => "#{@dnsimple_email}:#{@dnsimple_token}")
            end
          else
            raise ArgumentError.new("Insufficient credentials to properly authenticate!")
          end
          params[:headers].merge!(
            "Accept" => "application/json",
            "Content-Type" => "application/json"
          )

          version = params.delete(:version) || 'v1'
          params[:path] = File.join('/', version, params[:path])

          response = @connection.request(params)

          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end
      end
    end
  end
end
