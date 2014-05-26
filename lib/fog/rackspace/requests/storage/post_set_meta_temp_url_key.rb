module Fog
  module Storage
    class Rackspace
      class Real
        # Set the account wide Temp URL Key. This is a secret key that's
        # used to generate signed expiring URLs.
        #
        # Once the key has been set with this request you should create new
        # Storage objects with the :rackspace_temp_url_key option then use
        # the get_object_https_url method to generate expiring URLs.
        #
        # *** CAUTION *** changing this secret key will invalidate any expiring
        # URLS generated with old keys.
        #
        # ==== Parameters
        # * key<~String> - The new Temp URL Key
        #
        # ==== Returns
        # * response<~Excon::Response>
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # ==== See Also
        # http://docs.rackspace.com/files/api/v1/cf-devguide/content/Set_Account_Metadata-d1a4460.html
        def post_set_meta_temp_url_key(key)
          request(
            :expects  => [201, 202, 204],
            :method   => 'POST',
            :headers  => {'X-Account-Meta-Temp-Url-Key' => key}
          )
        end
      end

      class Mock
        def post_set_meta_temp_url_key(key)
          account_meta['X-Account-Meta-Temp-Url-Key'] = key

          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
