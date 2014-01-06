module Fog
  module StormOnDemand
    module RealShared

      API_URL = 'https://api.stormondemand.com'
      API_VERSION = 'v1'
      
      def initialize(options={})
        uri = URI.parse(options[:storm_on_demand_auth_url] ||= API_URL)
        @connection_options = options[:connection_options] || {}
        @host       = uri.host
        @path       = uri.path
        @persistent = options[:persistent] || false
        @port       = uri.port
        @scheme     = uri.scheme
        @storm_on_demand_username = options[:storm_on_demand_username]
        @storm_on_demand_password = options[:storm_on_demand_password]
        @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
      end

      def reload
        @connection.reset
      end

      def request(params)
        begin
          response = @connection.request(params.merge!({
            :headers  => {
              'Content-Type' => 'application/json',
              'Authorization' => 'Basic ' << Base64.encode64("#{@storm_on_demand_username}:#{@storm_on_demand_password}").chomp
            }.merge!(params[:headers] || {}),
            :path     => "#{@path}/#{API_VERSION}#{params[:path]}",
            :expects  => 200,
            :method   => :post
          }))
        rescue Excon::Errors::HTTPStatusError => error
          raise case error
          when Excon::Errors::NotFound
            Fog::StormOnDemand::Compute::NotFound.slurp(error)
          else
            error
          end
        end
        unless response.body.empty?
          response.body = Fog::JSON.decode(response.body)
        end
        if response.body.has_key?('error_class')
          raise(Fog::Compute::StormOnDemand::Error, response.body.inspect)
        end
        response
      end
    end
  end
end
