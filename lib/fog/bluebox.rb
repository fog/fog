module Fog
  module Bluebox

    class Error < Fog::Errors::Error; end
    class NotFound < Fog::Errors::NotFound; end

    def self.new(options={})

      unless @required
        require 'fog/bluebox/models/flavor'
        require 'fog/bluebox/models/flavors'
        require 'fog/bluebox/models/images'
        require 'fog/bluebox/models/server'
        require 'fog/bluebox/models/servers'
        require 'fog/bluebox/requests/create_block'
        require 'fog/bluebox/requests/destroy_block'
        require 'fog/bluebox/requests/get_block'
        require 'fog/bluebox/requests/get_blocks'
        require 'fog/bluebox/requests/get_product'
        require 'fog/bluebox/requests/get_products'
        require 'fog/bluebox/requests/get_template'
        require 'fog/bluebox/requests/get_templates'
        require 'fog/bluebox/requests/reboot_block'
        @required = true
      end

      unless options[:bluebox_api_key]
        raise ArgumentError.new('bluebox_api_key is required to access Blue Box')
      end
      unless options[:bluebox_customer_id]
        raise ArgumentError.new('bluebox_customer_id is required to access Blue Box')
      end
      if Fog.mocking?
        Fog::Bluebox::Mock.new(options)
      else
        Fog::Bluebox::Real.new(options)
      end
    end

    def self.reset_data(keys=Mock.data.keys)
      Mock.reset_data(keys)
    end

    class Mock

      def self.data
        @data ||= Hash.new do |hash, key|
          hash[key] = {}
        end
      end

      def self.reset_data(keys=data.keys)
        for key in [*keys]
          data.delete(key)
        end
      end

      def initialize(options={})
        @bluebox_api_key = options[:bluebox_api_key]
        @data = self.class.data[@bluebox_api_key]
      end

    end

    class Real

      def initialize(options={})
        @bluebox_api_key      = options[:bluebox_api_key]
        @bluebox_customer_id  = options[:bluebox_customer_id]
        @host   = options[:bluebox_host]    || "boxpanel.blueboxgrp.com"
        @port   = options[:bluebox_port]    || 443
        @scheme = options[:bluebox_scheme]  || 'https'
      end

      def request(params)
        @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
        params[:headers] ||= {}
        params[:headers].merge!({
          'Authorization' => "Basic #{Base64.encode64([@bluebox_customer_id, @bluebox_api_key].join(':')).delete("\r\n")}"
        })

        begin
          response = @connection.request({:host => @host}.merge!(params))
        rescue Excon::Errors::Error => error
          case error
          when Excon::Errors::NotFound
            raise Fog::Bluebox::NotFound
          else
            raise error
          end
        end
        unless response.body.empty?
          response.body = JSON.parse(response.body)
        end
        response
      end

    end
  end
end
