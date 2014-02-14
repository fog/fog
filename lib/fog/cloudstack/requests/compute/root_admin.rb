  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # 
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0//root_admin/]
          def root_admin(options={})
            options.merge!(
              'command' => 'root_admin'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
