module Fog
  module DNS
    class Rage4
      class Real
        # Delete a specific domain
        # ==== Parameters
        # * id<~Integer> - numeric ID
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #      * 'status'<~Boolean>
        #      * 'id'<~Integer>
        #      * 'error'<~String>
        def delete_domain(id)
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "/rapi/deletedomain/#{id}" )
        end
      end
    end
  end
end
