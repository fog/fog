module Fog
  module Compute
    class Cloudstack

      class Real
        # Disables static rule for given ip address
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/disableStaticNat.html]
        def disable_static_nat(ipaddressid, options={})
          options.merge!(
            'command' => 'disableStaticNat', 
            'ipaddressid' => ipaddressid  
          )
          request(options)
        end
      end

    end
  end
end

