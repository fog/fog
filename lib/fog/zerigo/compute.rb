module Fog
  module Zerigo
    class Compute < Fog::Service

      requires :zerigo_email, :zerigo_password
      recognizes :timeout, :persistent

      # model_path 'fog/zerigo/models/compute'
      # model       :server
      # collection  :servers

      request_path 'fog/zerigo/requests/compute'
      request :list_zones
      request :count_zones
      request :get_zone
      request :get_zone_stats
      request :create_zone
      request :update_zone
      request :delete_zone
      request :list_hosts
      request :find_hosts
      request :count_hosts
      request :get_host
      request :create_host
      request :update_host
      request :delete_host

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
          @zerigo_email = options[:zerigo_email]
          @zerigo_password = options[:zerigo_password]
          @data = self.class.data[@zerigo_email]
          @data = self.class.data[@zerigo_password]
        end

      end

      class Real

        def initialize(options={})
          @zerigo_email     = options[:zerigo_email]
          @zerigo_password  = options[:zerigo_password]
          @host   = options[:host]    || "ns.zerigo.com"
          @port   = options[:port]    || 80
          @scheme = options[:scheme]  || 'http'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", options[:persistent])
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:headers] ||= {}
          key= "#{@zerigo_email}:#{@zerigo_password}"
          params[:headers].merge!({
            'Authorization' => "Basic #{Base64.encode64(key).delete("\r\n")}"
          })
          case params[:method]
          when 'DELETE', 'GET', 'HEAD'
            params[:headers]['Accept'] = 'application/xml'
          when 'POST', 'PUT'
            params[:headers]['Content-Type'] = 'application/xml'
          end

          begin
            response = @connection.request(params.merge!({:host => @host}))
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Zerigo::Compute::NotFound.slurp(error)
            else
              error
            end
          end

          response
        end

      end
    end
  end
end
