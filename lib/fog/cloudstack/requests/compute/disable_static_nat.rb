  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Disables static rule for given ip address
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/disableStaticNat.html]
          def disable_static_nat(options={})
            options.merge!(
              'command' => 'disableStaticNat'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
