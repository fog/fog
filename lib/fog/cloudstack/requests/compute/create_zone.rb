module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createZone.html]
        def create_zone(internaldns1, name, networktype, dns1, options={})
          options.merge!(
            'command' => 'createZone', 
            'internaldns1' => internaldns1, 
            'name' => name, 
            'networktype' => networktype, 
            'dns1' => dns1  
          )
          request(options)
        end
      end

    end
  end
end

