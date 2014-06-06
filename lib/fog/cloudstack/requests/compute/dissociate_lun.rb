module Fog
  module Compute
    class Cloudstack

      class Real
        # Dissociate a LUN
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/dissociateLun.html]
        def dissociate_lun(iqn, path, options={})
          options.merge!(
            'command' => 'dissociateLun', 
            'iqn' => iqn, 
            'path' => path  
          )
          request(options)
        end
      end

    end
  end
end

