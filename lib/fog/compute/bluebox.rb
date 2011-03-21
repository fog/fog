module Fog
  module Bluebox
    class Compute < Fog::Service

      requires :bluebox_api_key, :bluebox_customer_id
      recognizes :bluebox_host, :bluebox_port, :bluebox_scheme, :persistent
      recognizes :provider # remove post deprecation

      model_path 'fog/compute/models/bluebox'
      model       :flavor
      collection  :flavors
      model       :image
      collection  :images
      model       :server
      collection  :servers

      request_path 'fog/compute/requests/bluebox'
      request :create_block
      request :destroy_block
      request :get_block
      request :get_blocks
      request :get_product
      request :get_products
      request :get_template
      request :get_templates
      request :reboot_block

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Bluebox::Compute.new is deprecated, use Fog::Compute.new(:provider => 'Bluebox') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          @bluebox_api_key = options[:bluebox_api_key]
          @data = self.class.data[@bluebox_api_key]
        end

        def reset_data
          self.class.data.delete(@bluebox_api_key)
          @data = self.class.data[@bluebox_api_key]
        end

      end

      class Real

        def initialize(options={})
          unless options.delete(:provider)
            location = caller.first
            warning = "[yellow][WARN] Fog::Bluebox::Compute.new is deprecated, use Fog::Compute.new(:provider => 'Bluebox') instead[/]"
            warning << " [light_black](" << location << ")[/] "
            Formatador.display_line(warning)
          end

          require 'json'
          @bluebox_api_key      = options[:bluebox_api_key]
          @bluebox_customer_id  = options[:bluebox_customer_id]
          @host   = options[:bluebox_host]    || "boxpanel.bluebox.net"
          @port   = options[:bluebox_port]    || 443
          @scheme = options[:bluebox_scheme]  || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", options[:persistent])
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:headers] ||= {}
          params[:headers].merge!({
            'Authorization' => "Basic #{Base64.encode64([@bluebox_customer_id, @bluebox_api_key].join(':')).delete("\r\n")}"
          })

          begin
            response = @connection.request(params.merge!({:host => @host}))
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Bluebox::Compute::NotFound.slurp(error)
            else
              error
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
end
