module Fog
  module Slicehost
    class Compute < Fog::Service

      requires :slicehost_password
      recognizes :host, :port, :scheme, :persistent
      recognizes :provider # remove post deprecation

      model_path 'fog/compute/models/slicehost'
      model       :flavor
      collection  :flavors
      model       :image
      collection  :images
      model       :server
      collection  :servers

      request_path 'fog/compute/requests/slicehost'
      request :create_slice
      request :delete_slice
      request :get_backups
      request :get_flavor
      request :get_flavors
      request :get_image
      request :get_images
      request :get_slice
      request :get_slices
      request :reboot_slice

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Slicehost::Compute.new is deprecated, use Fog::Compute.new(:provider => 'Slicehost') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          @slicehost_password = options[:slicehost_password]
          @data = self.class.data[@slicehost_password]
        end

        def reset_data
          self.class.data.delete(@slicehost_password)
          @data = self.class.data[@slicehost_password]
        end

      end

      class Real

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Slicehost::Compute.new is deprecated, use Fog::Compute.new(:provider => 'Slicehost') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          require 'fog/core/parser'

          @slicehost_password = options[:slicehost_password]
          @host   = options[:host]    || "api.slicehost.com"
          @port   = options[:port]    || 443
          @scheme = options[:scheme]  || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", options[:persistent])
        end

        def reload
          @connection.reset
        end

        def request(params)
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
            response = @connection.request(params.merge!({:host => @host}))
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Slicehost::Compute::NotFound.slurp(error)
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
