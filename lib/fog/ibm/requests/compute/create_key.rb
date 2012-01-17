module Fog
  module Compute
    class IBM
      class Real

        # Create a key
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def create_key(name, public_key=nil)
          request(
            :method   => 'POST',
            :expects  => 200,
            :path     => '/keys',
            :body => {
              'name' => name,
              'publicKey' => public_key
            }
          )
        end

      end
    end
  end
end
