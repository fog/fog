module Fog
  module Compute
    class IBM
      class Real

        # Get a key
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def get_key(key_name)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/keys/#{key_name}"
          )
        end

      end
    end
  end
end
