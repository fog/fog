require 'fog/linode/core'

module Fog
  module DNS
    class Linode < Fog::Service
      requires :linode_api_key
      recognizes :port, :scheme, :persistent

      model_path 'fog/linode/models/dns'
      model       :record
      collection  :records
      model       :zone
      collection  :zones

      request_path 'fog/linode/requests/dns'
      request :domain_create
      request :domain_delete
      request :domain_list
      request :domain_update
      request :domain_resource_create
      request :domain_resource_delete
      request :domain_resource_list
      request :domain_resource_update

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
          @linode_api_key = options[:linode_api_key]
        end

        def data
          self.class.data[@linode_api_key]
        end

        def reset_data
          self.class.data.delete(@linode_api_key)
        end
      end

      class Real
        def initialize(options={})
          @connection_options = options[:connection_options] || {}
          @host           = options[:host]        || "api.linode.com"
          @linode_api_key = options[:linode_api_key]
          @persistent     = options[:persistent]  || false
          @port           = options[:port]        || 443
          @scheme         = options[:scheme]      || 'https'
          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:query] ||= {}
          params[:query].merge!(:api_key => @linode_api_key)

          response = @connection.request(params)

          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
            if data = response.body['ERRORARRAY'].first
              error = case data['ERRORCODE']
              when 5
                Fog::DNS::Linode::NotFound
              else
                Fog::DNS::Linode::Error
              end
              raise error.new(data['ERRORMESSAGE'])
            end
          end
          response
        end
      end
    end
  end
end
