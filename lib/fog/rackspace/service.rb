module Fog
  module Rackspace
    class Service

      def service_name
        raise Fog::Errors::NotImplemented.new("Please implement the #service_name method")
      end

      def region
        raise Fog::Errors::NotImplemented.new("Please implement the #region method")
      end

      def endpoint_uri(service_endpoint=nil, endpoint_name=nil)
        return @uri if @uri

        url = service_endpoint

        unless url
          if v1_authentication?
            raise "Service Endpoint must be specified via #{endpoint_name} parameter"
          else
            url = endpoint_uri_v2
          end
        end

        @uri = URI.parse url
      end

      def authenticate(options)
         self.send authentication_method, options
      end

      private

      def authentication_method
        if v2_authentication?
          :authenticate_v2
        else
          Fog::Logger.deprecation "Authentication using a v1.0/v1.1 endpoint is deprecated. Please specify a v2.0 endpoint using :rackpace_auth_url.\ 
          For a list of v2.0 endpoints refer to http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/Endpoints-d1e180.html"
         :authenticate_v1
        end
      end

      def v1_authentication?
        !v2_authentication?
      end

      def v2_authentication?
        @rackspace_auth_url.nil? || @rackspace_auth_url =~ /v2(\.\d)?\w*$/
      end

      def authenticate_v2(identity_options)
        hash = {
              :rackspace_api_key => identity_options[:rackspace_api_key],
              :rackspace_username => identity_options[:rackspace_username],
              :rackspace_auth_url => identity_options[:rackspace_auth_url],
              :connection_options => identity_options[:connection_options] || {}
        }

        @identity_service = Fog::Rackspace::Identity.new(hash)
        @auth_token = @identity_service.auth_token
      end

      def authenticate_v1(options)
        raise Fog::Errors::NotImplemented.new("Authentication of legacy endpoints is not implemented for this service.")
      end

      def endpoint_uri_v2
        @uri = @identity_service.service_catalog.get_endpoint(service_name, region)
      end

      def auth_token
        @auth_token || @identity_service.auth_token
      end

    end
  end
end
