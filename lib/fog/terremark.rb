module Fog
  class Terremark

    def self.reload
      load 'fog/terremark/parsers/get_catalog.rb'
      load 'fog/terremark/parsers/get_organization.rb'
      load 'fog/terremark/parsers/get_organizations.rb'
      load 'fog/terremark/parsers/get_vdc.rb'

      load 'fog/terremark/requests/get_catalog.rb'
      load 'fog/terremark/requests/get_organization.rb'
      load 'fog/terremark/requests/get_organizations.rb'
      load 'fog/terremark/requests/get_vdc.rb'
    end

    def initialize(options={})
      unless @terremark_password = options[:terremark_password]
        raise ArgumentError.new('terremark_password is required to access terremark')
      end
      unless @terremark_username = options[:terremark_username]
        raise ArgumentError.new('terremark_username is required to access terremark')
      end
      @host   = options[:host]   || "services.vcloudexpress.terremark.com"
      @path   = options[:path]   || "/api/v0.8"
      @port   = options[:port]   || 443
      @scheme = options[:scheme] || 'https'
      
      @cookie = get_organizations.headers['Set-Cookie']
    end

    private

    def request(params)
      @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")
      headers = {}
      if @cookie
        headers.merge!('Cookie' => @cookie)
      end
      response = @connection.request({
        :body     => params[:body],
        :expects  => params[:expects],
        :headers  => headers.merge!(params[:headers] || {}),
        :host     => @host,
        :method   => params[:method],
        :parser   => params[:parser],
        :path     => "#{@path}/#{params[:path]}"
      })
    end

    if Fog.mocking?

      srand(Time.now.to_i)

      class Mock
      end

    end

  end
end
Fog::Terremark.reload
