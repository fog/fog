module Fog
  module Compute
    class VcloudDirector
      class Real
        # This is used for manual testing.
        #
        # @api private
        def get_request(uri)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :path       => uri
          )
        end
      end
    end
  end
end
