require 'fog/cloudatcost/core'

module Fog
  module Compute
    class CloudAtCost < Fog::Service
      requires :api_key, :email


      model_path 'fog/cloudatcost/models'
      model :server
      collection :servers
      model :task
      collection :tasks
      model :template
      collection :templates

      request_path 'fog/cloudatcost/requests'
      request :list_servers
      request :list_tasks
      request :console
      request :create_server
      request :list_templates
      request :power_off
      request :power_on
      request :rename_server
      request :reset
      request :reverse_dns
      request :run_mode

      class Mock

        def initialize(options={})
          @api_key = options[:api_key]
          @email   = options[:email]
        end

      end

      class Real

        def initialize(options={})
          @api_key = options[:api_key]
          @email   = options[:email]
          persistent         = false
          @connection        = Fog::Core::Connection.new 'https://panel.cloudatcost.com', persistent, options
        end

        def request(params)
          params[:headers] ||= { 'Content-Type' => 'application/x-www-form-urlencoded' }
          params[:query] ||= {}
          required_params = {
            key: "#{@api_key}",
            login: "#{@email}"
          }
          begin
            if params[:method] == 'POST' 
              params_body = required_params.merge(params[:body])
              params[:body] = params_body.reduce(""){ |acc,(x,y)| "#{acc}&#{x}=#{y}" }
            else
              params[:query] = required_params.merge(params[:query])
            end
            response = @connection.request(params)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
                  when Excon::Errors::NotFound
                    Fog::Compute::Bluebox::NotFound.slurp(error)
                  else
                    error
                  end
          end
          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

      end
    end
  end
end
