require 'fog/openstack/core'

module Fog
  module Image
    class OpenStack < Fog::Service

      # Fog::Image::OpenStack.new() will return a Fog::Image::OpenStack::V2 or a Fog::Image::OpenStack::V3,
      #  choosing the latest available
      def self.new(args = {})
        @openstack_auth_uri = URI.parse(args[:openstack_auth_url]) if args[:openstack_auth_url]
        if self.inspect == 'Fog::Image::OpenStack'
          service = Fog::Image::OpenStack::V2.new(args) unless args.empty?
          service ||= Fog::Image::OpenStack::V1.new(args)
        else
          service = Fog::Service.new(args)
        end
        service
      end

      module Common
        attr_reader :unscoped_token

        include Fog::OpenStack::Core

        def request(params)
          retried = false
          begin
            std_headers = {
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
                'X-Auth-Token' => @auth_token
            }
            param_headers = params.fetch(:headers,{})

            response = @connection.request(params.merge({
              :headers => std_headers.merge(param_headers),
              :path => "#{@path}/#{params[:path]}"
            }))
          rescue Excon::Errors::Unauthorized => error
            raise if retried
            retried = true

            @openstack_must_reauthenticate = true
            authenticate
            retry
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
                    when Excon::Errors::NotFound
                      Fog::Image::OpenStack::NotFound.slurp(error)
                    else
                      error
                  end
          end
          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body) unless params[:raw_body]
          end
          response
        end
      end
    end
  end
end
