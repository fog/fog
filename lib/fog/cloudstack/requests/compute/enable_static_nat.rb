module Fog
  module Compute
    class Cloudstack

      class Real
        # Enables static nat for given ip address
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/enableStaticNat.html]
        def enable_static_nat(ipaddressid, virtualmachineid, options={})
          options.merge!(
            'command' => 'enableStaticNat', 
            'ipaddressid' => ipaddressid, 
            'virtualmachineid' => virtualmachineid  
          )
          request(options)
        end
      end

    end
  end
end

