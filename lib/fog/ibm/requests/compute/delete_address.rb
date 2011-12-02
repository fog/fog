module Fog
  module Compute
    class IBM
      class Real

        # Delete an address
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
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
