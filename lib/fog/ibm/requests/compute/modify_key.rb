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
          options = {
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/keys/#{key_name}",
          }
          options.merge!(Fog::IBM.form_body(params))
          request(options)
        end

      end
    end
  end
end
