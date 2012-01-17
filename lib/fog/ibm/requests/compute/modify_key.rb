module Fog
  module Compute
    class IBM
      class Real

        # Modify a key
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def modify_key(key_name, params={})
          request(
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/keys/#{key_name}",
            :body     => params
          )
        end

      end
    end
  end
end
