module Fog
  module Bluebox

    def self.new(options={})

      unless @required
        require 'fog/bluebox/models/templates'
        require 'fog/bluebox/requests/get_templates'
        require 'fog/bluebox/models/products'
        require 'fog/bluebox/requests/get_products'
        @required = true
      end

      unless options[:bluebox_api_key]
        raise ArgumentError.new('bluebox_api_key is required to access Blue Box')
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
        @bluebox_api_key = options[:bluebox_api_key]
        @host   = options[:host]    || "boxpanel.blueboxgrp.com"
        @port   = options[:port]    || 443
        @scheme = options[:scheme]  || 'https'
      end

      def request(params)
        @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
        headers = {
          'Authorization' => "Basic #{Base64.encode64(@bluebox_api_key).delete("\r\n")}"
        }
        case params[:method]
        when 'DELETE', 'GET', 'HEAD'
          headers['Accept'] = 'application/xml'
        when 'POST', 'PUT'
          headers['Content-Type'] = 'application/xml'
        end

        response = @connection.request({
          :body     => params[:body],
          :expects  => params[:expects],
          :headers  => headers.merge!(params[:headers] || {}),
          :host     => @host,
          :method   => params[:method],
          :parser   => params[:parser],
          :path     => params[:path]
        })

        response
      end

    end
  end
end
