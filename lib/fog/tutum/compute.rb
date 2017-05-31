require 'fog/tutum/core'

module Fog
  module Compute
    class Tutum < Fog::Service
      requires   :tutum_username, :tutum_api_key
      recognizes :tutum_url

      model_path 'fog/tutum/models/compute'
      model      :server
      collection :servers
      model      :application
      collection :applications
      model      :image
      collection :images

      request_path 'fog/tutum/requests/compute'
      request :container_all
      request :container_create
      request :container_get
      request :container_action
      request :container_logs
      request :container_terminate
      request :image_all
      request :image_get
      request :image_create
      request :image_update
      request :image_delete
      request :application_all
      request :application_get
      request :application_create
      request :application_update
      request :application_action
      request :application_terminate

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :servers => [],
              :ssh_keys => []
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @tutum_username = options[:tutum_username]
          @tutum_api_key = options[:tutum_api_key]
        end

        def data
          self.class.data[@tutum_api_key]
          self.class.data[@tutum_username]
        end

        def reset_data
          self.class.data.delete(@tutum_api_key)
          self.class.data.delete(@tutum_username)
        end
      end

      class Real
        def initialize(options={})
          @tutum_username = options[:tutum_username]
          @tutum_api_key  = options[:tutum_api_key]
          @tutum_api_url  = options[:tutum_api_url] || "https://app.tutum.co"
          @tutum_version  = options[:tutum_version] || "v1"
          @connection     = Fog::XML::Connection.new(@tutum_api_url)
        end

        def reload
          @connection.reset
        end

        def request(params)
          params[:headers] ||= {}
          params[:headers].merge!('Authorization' => "ApiKey #{@tutum_username}:#{@tutum_api_key}")

          # need a better way to do this
          params[:path] = "/api/#{@tutum_version}/#{params[:path]}"
          response = parse @connection.request(params)

          case response.status
          when 401
            raise Fog::Errors::Security.new
          when 404
            raise Fog::Errors::NotFound.new
          when 400
            raise Fog::Errors::Execution.new
          end
          response.body
        end
        
        private

        def parse(response)
          return response if response.body.empty?
          response.body = Fog::JSON.decode(response.body)
          response
        end
      end
    end
  end
end
