  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Enables static nat for given ip address
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/enableStaticNat.html]
          def enable_static_nat(options={})
            options.merge!(
              'command' => 'enableStaticNat'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
