require 'fog/openstack/core'

module Fog
  module OpenStack
    module Common
      attr_reader :unscoped_token

      include Fog::OpenStack::Core

      def request(params)
        retried = false
        begin
          std_headers   = {
              'Content-Type' => 'application/json',
              'Accept'       => 'application/json',
              'X-Auth-Token' => @auth_token
          }
          param_headers = params.fetch(:headers, {})

          response = @connection.request(params.merge({
                                                          :headers => std_headers.merge(param_headers),
                                                          :path    => "#{@path}/#{params[:path]}"
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
                    self.class.not_found_class.slurp(error)
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
