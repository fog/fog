module Fog
  module Compute
    class Cloudstack

      class Real
        # Enables static nat for given ip address
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/enableStaticNat.html]
        def enable_static_nat(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'enableStaticNat') 
          else
            options.merge!('command' => 'enableStaticNat', 
            'ipaddressid' => args[0], 
            'virtualmachineid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

