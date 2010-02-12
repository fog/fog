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

    def self.dependencies
      [
        "fog/slicehost/models/flavor.rb",
        "fog/slicehost/models/flavors.rb",
        "fog/slicehost/models/image.rb",
        "fog/slicehost/models/images.rb",
        "fog/slicehost/models/server.rb",
        "fog/slicehost/models/servers.rb",
        "fog/slicehost/parsers/create_slice.rb",
        "fog/slicehost/parsers/get_backups.rb",
        "fog/slicehost/parsers/get_flavor.rb",
        "fog/slicehost/parsers/get_flavors.rb",
        "fog/slicehost/parsers/get_image.rb",
        "fog/slicehost/parsers/get_images.rb",
        "fog/slicehost/parsers/get_slice.rb",
        "fog/slicehost/parsers/get_slices.rb",
        "fog/slicehost/requests/create_slice.rb",
        "fog/slicehost/requests/delete_slice.rb",
        "fog/slicehost/requests/get_backups.rb",
        "fog/slicehost/requests/get_flavor.rb",
        "fog/slicehost/requests/get_flavors.rb",
        "fog/slicehost/requests/get_image.rb",
        "fog/slicehost/requests/get_images.rb",
        "fog/slicehost/requests/get_slice.rb",
        "fog/slicehost/requests/get_slices.rb",
        "fog/slicehost/requests/reboot_slice.rb"
      ]
    end

    def self.reload
      self.dependencies.each {|dependency| load(dependency)}
      if Fog.mocking?
        reset_data
      end
    end

    def initialize(options={})
      unless @slicehost_password = options[:slicehost_password]
        raise ArgumentError.new('slicehost_password is required to access slicehost')
      end
      @host       = options[:host]      || "api.slicehost.com"
      @port       = options[:port]      || 443
      @scheme     = options[:scheme]    || 'https'
    end

    def request(params)
      @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
      headers = {
        'Authorization' => "Basic #{Base64.encode64(@slicehost_password).chomp!}"
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

Fog::Slicehost.dependencies.each {|dependency| require(dependency)}
