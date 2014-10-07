module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createZone.html]
        def create_zone(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createZone') 
          else
            options.merge!('command' => 'createZone', 
            'dns1' => args[0], 
            'internaldns1' => args[1], 
            'networktype' => args[2], 
            'name' => args[3])
          end
          request(options)
        end
      end

    end
  end
end

