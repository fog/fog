module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates an account.
        #
        # {CloudStack API Reference}[http://incubator.apache.org/cloudstack/docs/api/apidocs-4.0.0/root_admin/associateIpAddress.html]
        def enable_static_nat(options={})
          options.merge!(
              'command' => 'enableStaticNat'
          )

          request(options)
        end

      end
    end
  end
end