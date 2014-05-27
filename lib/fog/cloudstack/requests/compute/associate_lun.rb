module Fog
  module Compute
    class Cloudstack

      class Real
        # Associate a LUN with a guest IQN
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/associateLun.html]
        def associate_lun(options={})
          options.merge!(
            'command' => 'associateLun', 
            'name' => options['name'], 
            'iqn' => options['iqn']  
          )
          request(options)
        end
      end

    end
  end
end

