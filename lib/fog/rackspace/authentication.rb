module Fog
  module Rackspace
    module Authentication  
  
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
        h = {
              :rackspace_api_key => identity_options[:rackspace_api_key],
              :rackspace_username => identity_options[:rackspace_username],
              :rackspace_auth_url => identity_options[:rackspace_auth_url]
        }
        
        @identity_service = Fog::Rackspace::Identity.new(h)
        @auth_token = @identity_service.auth_token
        endpoint_uri
      end
    end
  end
end