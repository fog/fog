module Fog
  module DNS
    class DNSimple
      class Real

        # Get the details for a specific domain in your account. You
        # may pass either the domain numeric ID or the domain name itself.
        # ==== Parameters
        # * id<~String> - domain name or numeric ID
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'domains'<~Array>
        #       * 'name'<~String>
        #       * 'expires_at'<~String>
        #       * 'created_at'<~String>
        #       * 'registration_status'<~String>
        #       * 'updated_at'<~String>
        #       * 'registrant_id'<~Integer>
        #       * 'id'<~Integer>
        #       * 'user_id'<~Integer>
        #       * 'name_server_status'<~String>
        def list_domains
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => '/domains'
                  )
        end

      end
    end
  end
end
