require 'fog/openstack/core'

module Fog
  module Identity
    class OpenStack < Fog::Service

      # Fog::Identity::OpenStack.new() will return a Fog::Identity::OpenStack::V2 or a Fog::Identity::OpenStack::V3,
      #  depending on whether the auth URL is for an OpenStack Identity V2 or V3 API endpoint
      def self.new(args = {})
        if self.inspect == 'Fog::Identity::OpenStack'
          if args[:openstack_auth_url]
            @openstack_auth_uri = URI.parse(args[:openstack_auth_url])
            if @openstack_auth_uri.path =~ /\/v3/
              service = Fog::Identity::OpenStack::V3.new(args)
            end
          end
          service ||= Fog::Identity::OpenStack::V2.new(args)
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
            response = @connection.request(params.merge({
              :headers => params.fetch(:headers,{}).merge({
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
                'X-Auth-Token' => @auth_token
              }),
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
                      Fog::Identity::OpenStack::NotFound.slurp(error)
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
