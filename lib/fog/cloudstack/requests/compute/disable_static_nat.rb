module Fog
  module Compute
    class Cloudstack
      class Real

        # Disable static nat.
        #
        # {CloudStack API Reference}[http://incubator.apache.org/cloudstack/docs/api/apidocs-4.0.0/root_admin/disableStaticNat.html]
        def disable_static_nat(options={})
          options.merge!(
              'command' => 'disableStaticNat'
          )

          request(options)
        end

      end
    end
  end
end