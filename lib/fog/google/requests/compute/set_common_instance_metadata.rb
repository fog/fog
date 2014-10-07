module Fog
  module Compute
    class Google
      class Mock
        def set_common_instance_metadata(identity, current_fingerprint, metadata = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_common_instance_metadata(identity, current_fingerprint, metadata = {})
          api_method = @compute.projects.set_common_instance_metadata
          parameters = {
            :project => identity,
          }
          body_object = {
            :fingerprint => current_fingerprint,
            :items => Array(metadata).map { |pair| { :key => pair[0], :value => pair[1] } },
          }

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
