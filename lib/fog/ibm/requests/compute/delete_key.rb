module Fog
  module Compute
    class IBM
      class Real

        # Delete a key
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def delete_key(key_name)
          request(
            :method   => 'DELETE',
            :expects  => 200,
            :path     => "/keys/#{key_name}"
          )
        end

      end
    end
  end
end
