  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a vm group
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createInstanceGroup.html]
          def create_instance_group(options={})
            options.merge!(
              'command' => 'createInstanceGroup'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
