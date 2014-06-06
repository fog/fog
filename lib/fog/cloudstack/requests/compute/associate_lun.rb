module Fog
  module Compute
    class Cloudstack

      class Real
        # Associate a LUN with a guest IQN
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/associateLun.html]
        def associate_lun(iqn, name, options={})
          options.merge!(
            'command' => 'associateLun', 
            'iqn' => iqn, 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

