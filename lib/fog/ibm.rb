require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module IBM

    extend Fog::Provider

    service(:compute, 'ibm/compute', 'Compute')
    service(:storage, 'ibm/storage', 'Storage')

    class Connection < Fog::Connection

      ENDPOINT = 'https://www-147.ibm.com/computecloud/enterprise/api/rest/20100331'

      def initialize(user, password)
        require 'multi_json'
        @user = user
        @password = password
        @endpoint = URI.parse(ENDPOINT)
        @base_path = @endpoint.path
        super("#{@endpoint.scheme}://#{@endpoint.host}:#{@endpoint.port}")
      end

      def request(options)
        options[:path] = @base_path + options[:path]
        options[:headers] ||= {}
        options[:headers]['Authorization'] = auth_header
        options[:headers]['Accept'] = 'application/json'
        options[:headers]['Accept-Encoding'] = 'gzip'
        unless options[:body].nil?
          options[:headers]['Content-Type'] = 'application/x-www-form-urlencoded'
          options[:body] = form_encode(options[:body])
        end
        response = super(options)
        unless response.body.empty?
          response.body = MultiJson.decode(response.body)
        end
        response
      end

      def auth_header
        @auth_header ||= 'Basic ' + Base64.encode64("#{@user}:#{@password}").gsub("\n",'')
      end

      def form_encode(params)
        params.reject {|k, v| v.nil? }.map {|pair| pair.map {|x| URI.escape(x) }.join('=') }.join('&')
      end
    end

  end
end
