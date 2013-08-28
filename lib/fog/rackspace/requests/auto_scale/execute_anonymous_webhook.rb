module Fog
  module Rackspace
    class AutoScale
      class Real

        def execute_anonymous_webhook(capability_version, capability_hash)
          request(
            :expects => [202],
            :method => 'POST',
            :path => "execute/#{capability_version}/#{capability_hash}"
          )
        end
      end

      class Mock
        def execute_anonymous_webhook(capability_version, capability_hash)
           Fog::Mock.not_implemented
        end
      end
    end
  end
end