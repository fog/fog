module Fog
  module Rackspace
    class Service

      def endpoint_uri(service_endpoint_url=nil)
        raise Fog::Errors::NotImplemented.new("Retrieving endpoint is not implemented for this service.")
      end

      def authenticate(options)
         self.send authentication_method, options
       end

      private

      def authentication_method
        return :authenticate_v2 unless @rackspace_auth_url
        if @rackspace_auth_url =~ /v2(\.\d)?\w*$/
          :authenticate_v2
        else
         :authenticate_v1
       end
      end

      def v1_authentication?
        @identity_service.nil?
      end

      def v2_authentication?
        @identity_service != nil
      end

      def authenticate_v2(identity_options)
        hash = {
              :rackspace_api_key => identity_options[:rackspace_api_key],
              :rackspace_username => identity_options[:rackspace_username],
              :rackspace_auth_url => identity_options[:rackspace_auth_url]
        }

        @identity_service = Fog::Rackspace::Identity.new(hash)
        @identity_service.auth_token
      end

      def authenticate_v1(options)
        raise Fog::Errors::NotImplemented.new("Authentication of legacy endpoints is not implemented for this service.")
      end

      def endpoint_uri_v2(service_name, region)
        @identity_service.service_catalog.get_endpoint(service_name, region)
      end

    end
  end
end
