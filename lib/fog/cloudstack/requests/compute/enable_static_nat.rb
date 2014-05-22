module Fog
  module Compute
    class Cloudstack

      class Real
        # Enables static nat for given ip address
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/enableStaticNat.html]
        def enable_static_nat(options={})
          options.merge!(
            'command' => 'enableStaticNat',
            'virtualmachineid' => options['virtualmachineid'], 
            'ipaddressid' => options['ipaddressid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

