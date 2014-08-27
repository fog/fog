module Fog
  module Compute
    class Cloudstack

      class Real
        # Disables static rule for given ip address
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/disableStaticNat.html]
        def disable_static_nat(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'disableStaticNat') 
          else
            options.merge!('command' => 'disableStaticNat', 
            'ipaddressid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

