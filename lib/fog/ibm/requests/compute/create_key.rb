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
        def create_key(name, public_key, extra_params={})
          options = {
            :method   => 'POST',
            :expects  => 200,
            :path     => '/keys',
          }
          params = {
            'name' => name,
            'publicKey' => public_key
          }
          options.merge!(Fog::IBM.form_body(params.merge(extra_params)))
          request(options)
        end

      end
    end
  end
end
