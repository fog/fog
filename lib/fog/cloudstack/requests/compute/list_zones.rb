module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists zones
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listZones.html]
        def list_zones(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listZones') 
          else
            options.merge!('command' => 'listZones')
          end
          request(options)
        end
      end
 
      class Mock
        def list_zones(options={})
          zones = self.data[:zones].values

          {
            "listzonesresponse"=>
            {
              "count" => zones.size,
              "zone" => zones
            }
          }
        end
      end 
    end
  end
end

