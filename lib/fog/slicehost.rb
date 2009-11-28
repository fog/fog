module Fog
  class Slicehost

    if Fog.mocking?
      def self.data
        @data
      end
      def self.reset_data
        @data = {}
      end
    end

    def self.reload
      load "fog/slicehost/parsers/create_slice.rb"
      load "fog/slicehost/parsers/get_backups.rb"
      load "fog/slicehost/parsers/get_flavors.rb"
      load "fog/slicehost/parsers/get_images.rb"
      load "fog/slicehost/parsers/get_slices.rb"

      load "fog/slicehost/requests/create_slice.rb"
      load "fog/slicehost/requests/delete_slice.rb"
      load "fog/slicehost/requests/get_backups.rb"
      load "fog/slicehost/requests/get_flavors.rb"
      load "fog/slicehost/requests/get_images.rb"
      load "fog/slicehost/requests/get_slices.rb"

      if Fog.mocking?
        reset_data
      end
    end

    def initialize(options={})
      @password   = options[:password]
      @host       = options[:host]      || "api.slicehost.com"
      @port       = options[:port]      || 443
      @scheme     = options[:scheme]    || 'https'
      @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
    end

    def request(params)
      headers = {
        'Authorization' => "Basic #{Base64.encode64(@password).gsub("\n",'')}"
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
        :headers  => headers,
        :host     => @host,
        :method   => params[:method],
        :parser   => params[:parser],
        :path     => params[:path]
      })
      response
    end

  end
end

Fog::Slicehost.reload
