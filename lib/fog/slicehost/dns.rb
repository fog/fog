require File.expand_path(File.join(File.dirname(__FILE__), '..', 'slicehost'))
require 'fog/dns'

module Fog
  module DNS
    class Slicehost < Fog::Service

      requires :slicehost_password
      recognizes :host, :port, :scheme, :persistent

      model_path 'fog/slicehost/models/dns'
      model       :record
      collection  :records
      model       :zone
      collection  :zones

      request_path 'fog/slicehost/requests/dns'
      request :create_record
      request :create_zone
      request :delete_record
      request :delete_zone
      request :get_record
      request :get_records
      request :get_zone
      request :get_zones

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
          @slicehost_password = options[:slicehost_password]
        end

        def data
          self.class.data[@slicehost_password]
        end

        def reset_data
          self.class.data.delete(@slicehost_password)
        end

      end

      class Real

        def initialize(options={})
          require 'fog/core/parser'

          @slicehost_password = options[:slicehost_password]
          @connection_options     = options[:connection_options] || {}
          @host       = options[:host]        || "api.slicehost.com"
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
          params[:headers].merge!({
            'Authorization' => "Basic #{Base64.encode64(@slicehost_password).delete("\r\n")}"
          })
          case params[:method]
          when 'DELETE', 'GET', 'HEAD'
            params[:headers]['Accept'] = 'application/xml'
          when 'POST', 'PUT'
            params[:headers]['Content-Type'] = 'application/xml'
          end

          begin
            response = @connection.request(params.merge!({:host => @host}))
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::DNS::Slicehost::NotFound.slurp(error)
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
