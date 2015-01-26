require 'fog/bluebox/core'

module Fog
  module Bluebox
    class BLB < Fog::Service
      requires :bluebox_api_key, :bluebox_customer_id
      recognizes :bluebox_host, :bluebox_port, :bluebox_scheme, :persistent

      model_path 'fog/bluebox/models/blb'

      model      :lb_application
      collection :lb_applications

      model      :lb_service
      collection :lb_services

      model      :lb_backend
      collection :lb_backends

      request_path 'fog/bluebox/requests/blb'

      request :get_lb_application
      request :get_lb_applications

      request :get_lb_service
      request :get_lb_services

      request :get_lb_backend
      request :get_lb_backends

      request :add_machine_to_lb_application

      request :add_machine_to_lb_backend

      request :remove_machine_from_lb_backend

      request :update_lb_backend_machine

      class Mock
      end

      class Real
        def initialize(options={})
          @bluebox_api_key      = options[:bluebox_api_key]
          @bluebox_customer_id  = options[:bluebox_customer_id]
          @connection_options   = options[:connection_options] || {}
          @host       = options[:bluebox_host]    || "boxpanel.bluebox.net"
          @persistent = options[:persistent]      || false
          @port       = options[:bluebox_port]    || 443
          @scheme     = options[:bluebox_scheme]  || 'https'
          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
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
            response = @connection.request(params)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::Bluebox::NotFound.slurp(error)
            else
              error
            end
          end
          unless response.body.empty? || params[:headers]['Accept'] == 'text/plain'
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end
      end
    end
  end
end
