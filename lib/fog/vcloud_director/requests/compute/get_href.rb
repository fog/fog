module Fog
  module Compute
    class VcloudDirector
      class Real
        # This is used for manual testing.
        #
        # @api private
        def get_href(href)
          request(
            :expects       => 200,
            :idempotent    => true,
            :method        => 'GET',
            :parser        => Fog::ToHashDocument.new,
            :override_path => true,
            :path          => URI.parse(href).path
          )
        end
      end
    end
  end
end
