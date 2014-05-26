module Fog
  module DNS
    class Rage4
      class Real
        # Get the lsit of all domains for your account.
        # ==== Parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'domains'<~Hash>
        #       * 'id'<~Integer>
        #       * 'name'<~String>
        #       * 'owner_email'<~String>
        #       * 'type'<~Integer>
        #       * 'subnet_mask'<~Integer>
        def list_domains
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => '/rapi/getdomains'
                  )
        end
      end

      class Mock
        def list_domains
          response = Excon::Response.new
          response.status = 200
          response.body = self.data[:domains]
          response
        end
      end
    end
  end
end
