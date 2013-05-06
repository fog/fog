require File.expand_path(File.join(File.dirname(__FILE__), '..', 'dreamhost'))
require 'fog/dns'

module Fog
  module DNS
    class Dreamhost < Fog::Service

      requires :dreamhost_api_key

      model_path 'fog/dreamhost/models/dns'
      model       :record
      model       :zone
      collection  :records
      collection  :zones

      request_path 'fog/dreamhost/requests/dns'
      request :create_record
      request :list_records
      request :delete_record

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
          @dreamhost_api_key  = options[:dreamhost_api_key]
        end

        def data
          self.class.data
        end

        def reset_data
          self.class.data.delete
        end

      end

      class Real

        def initialize(options={})
          require 'multi_json'

          @dreamhost_api_key  = options[:dreamhost_api_key]
          if options[:dreamhost_url]
            uri = URI.parse(options[:dreamhost_url])
            options[:host]    = uri.host
            options[:port]    = uri.port
            options[:scheme]  = uri.scheme
          end
          @host       = options[:host]        || "api.dreamhost.com"
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent)
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:query].merge!( { :key => @dreamhost_api_key, 
                                   :format => 'json' } )
          response = @connection.request(params)

          unless response.body.empty?
            response.body = MultiJson.decode(response.body)
          end
          if response.body['result'] != 'success'
            raise response.body['data']
          end
          response
        end
      end
    end
  end
end
