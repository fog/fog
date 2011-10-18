module Fog
  module Compute
    class GoGrid
      class Real

        # Get one or more passwords by id
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'id'<~String> - id of the password to retrieve
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
        def support_password_get(id, options={})
          request(
            :path     => 'support/password/get',
            :query    => {
              'id'    => id
            }.merge!(options)
          )
        end

      end
    end
  end
end
