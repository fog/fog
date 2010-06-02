module Fog
  module Slicehost

    class Error < Fog::Errors::Error; end
    class NotFound < Fog::Errors::NotFound; end

    def self.new(options={})

      unless @required
        require 'fog/slicehost/models/flavor'
        require 'fog/slicehost/models/flavors'
        require 'fog/slicehost/models/image'
        require 'fog/slicehost/models/images'
        require 'fog/slicehost/models/server'
        require 'fog/slicehost/models/servers'
        require 'fog/slicehost/requests/create_slice'
        require 'fog/slicehost/requests/delete_slice'
        require 'fog/slicehost/requests/get_backups'
        require 'fog/slicehost/requests/get_flavor'
        require 'fog/slicehost/requests/get_flavors'
        require 'fog/slicehost/requests/get_image'
        require 'fog/slicehost/requests/get_images'
        require 'fog/slicehost/requests/get_slice'
        require 'fog/slicehost/requests/get_slices'
        require 'fog/slicehost/requests/reboot_slice'
        @required = true
      end

      unless options[:slicehost_password]
        raise ArgumentError.new('slicehost_password is required to access slicehost')
      end
      if Fog.mocking?
        Fog::Slicehost::Mock.new(options)
      else
        Fog::Slicehost::Real.new(options)
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
        @slicehost_password = options[:slicehost_password]
        @data = self.class.data[@slicehost_password]
      end

    end

    class Real

      def initialize(options={})
        @slicehost_password = options[:slicehost_password]
        @host   = options[:host]    || "api.slicehost.com"
        @port   = options[:port]    || 443
        @scheme = options[:scheme]  || 'https'
      end

      def request(params)
        @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
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
          response = @connection.request({:host => @host}.merge!(params))
        rescue Excon::Errors::Error => error
          case error
          when Excon::Errors::NotFound
            raise Fog::Slicehost::NotFound
          else
            raise error
          end
        end

        response
      end

    end
  end
end
