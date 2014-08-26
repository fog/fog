module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createZone.html]
        def create_zone(options={})
          request(options)
        end


        def create_zone(dns1, internaldns1, networktype, name, options={})
          options.merge!(
            'command' => 'createZone', 
            'dns1' => dns1, 
            'internaldns1' => internaldns1, 
            'networktype' => networktype, 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

