require File.expand_path(File.join(File.dirname(__FILE__), '..', 'bluebox'))
require 'fog/compute'

module Fog
  module Compute
    class Bluebox < Fog::Service

      requires :bluebox_api_key, :bluebox_customer_id
      recognizes :bluebox_host, :bluebox_port, :bluebox_scheme, :persistent

      model_path 'fog/bluebox/models/compute'
      model       :flavor
      collection  :flavors
      model       :image
      collection  :images
      model       :server
      collection  :servers
      model       :location
      collection  :locations

      request_path 'fog/bluebox/requests/compute'
      request :create_block
      request :destroy_block
      request :get_block
      request :get_blocks
      request :get_location
      request :get_locations
      request :get_product
      request :get_products
      request :get_template
      request :get_templates
      request :create_template
      request :destroy_template
      request :reboot_block

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
          @bluebox_api_key = options[:bluebox_api_key]
        end

        def data
          self.class.data[@bluebox_api_key]
        end

        def reset_data
          self.class.data.delete(@bluebox_api_key)
        end

      end

      class Real

        def initialize(options={})
          require 'multi_json'
          @bluebox_api_key      = options[:bluebox_api_key]
          @bluebox_customer_id  = options[:bluebox_customer_id]
          @connection_options   = options[:connection_options] || {}
          @host       = options[:bluebox_host]    || "boxpanel.bluebox.net"
          @persistent = options[:persistent]      || false
          @port       = options[:bluebox_port]    || 443
          @scheme     = options[:bluebox_scheme]  || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:headers] ||= {}
          params[:headers].merge!({
            'Authorization' => "Basic #{Base64.encode64([@bluebox_customer_id, @bluebox_api_key].join(':')).delete("\r\n")}"
          })

          begin
            response = @connection.request(params.merge!({:host => @host}))
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::Bluebox::NotFound.slurp(error)
            else
              error
            end
          end
          unless response.body.empty?
            response.body = MultiJson.decode(response.body)
          end
          response
        end

      end
    end
  end
end
