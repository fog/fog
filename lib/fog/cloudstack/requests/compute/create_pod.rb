  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a new Pod.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createPod.html]
          def create_pod(options={})
            options.merge!(
              'command' => 'createPod'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
