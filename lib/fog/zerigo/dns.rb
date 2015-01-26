require 'fog/zerigo/core'

module Fog
  module DNS
    class Zerigo < Fog::Service
      requires :zerigo_email, :zerigo_token
      recognizes :host, :persistent, :port, :scheme, :timeout

      model_path 'fog/zerigo/models/dns'
      model       :record
      collection  :records
      model       :zone
      collection  :zones

      request_path 'fog/zerigo/requests/dns'
      request :count_hosts
      request :count_zones
      request :create_host
      request :create_zone
      request :delete_host
      request :delete_zone
      request :find_hosts
      request :get_host
      request :get_zone
      request :get_zone_stats
      request :list_zones
      request :list_hosts
      request :update_host
      request :update_zone

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = key == :zones ? [] : {}
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @zerigo_email = options[:zerigo_email]
          @zerigo_token = options[:zerigo_token]
        end

        def data
          self.class.data
        end

        def reset_data
          self.class.reset
        end

        def find_by_zone_id(zone_id)
          self.data[:zones].find { |z| z['id'] == zone_id }
        end

        def find_by_domain(domain)
          self.data[:zones].find { |z| z['domain'] == domain }
        end

        def find_host(host_id)
          self.data[:zones].map { |z| z['hosts'].find { |h| h['id'] == host_id } }.compact.first
        end
      end

      class Real
        def initialize(options={})

          @zerigo_email  = options[:zerigo_email]
          @zerigo_token  = options[:zerigo_token]
          @connection_options = options[:connection_options] || {}
          @host       = options[:host]        || "ns.zerigo.com"
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 80
          @scheme     = options[:scheme]      || 'http'
          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:headers] ||= {}
          key= "#{@zerigo_email}:#{@zerigo_token}"
          params[:headers].merge!({
            'Authorization' => "Basic #{Base64.encode64(key).delete("\r\n")}"
          })
          case params[:method]
          when 'DELETE', 'GET', 'HEAD'
            params[:headers]['Accept'] = 'application/xml'
          when 'POST', 'PUT'
            params[:headers]['Content-Type'] = 'application/xml'
          end

          begin
            response = @connection.request(params)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::DNS::Zerigo::NotFound.slurp(error)
            else
              error
            end
          end

          response
        end
      end
    end
  end
end
