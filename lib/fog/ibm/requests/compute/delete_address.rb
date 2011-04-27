module Fog
  module Compute
    class IBM
      class Real

        # Deletes the Address that the authenticated user manages with the specified :address_id
        #
        # ==== Parameters
        # * address_id<~String> - Id of address
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     *'success'<~Bool>: true or false for success
        def delete_address(address_id)
          request(
            :method   => 'DELETE',
            :expects  => 200,
            :path     => "/addresses/#{address_id}"
          )
        end

      end

      class Mock

        def delete_address(address_id)
          response = Excon::Response.new
          if address_exists? address_id
            self.data[:addresses].delete address_id
            response.status = 200
            response.body = { "success" => true }
          else
            response.status = 404
          end
          response
        end

        def address_exists?(address_id)
          self.data[:addresses].key? address_id
        end

      end
    end
  end
end
