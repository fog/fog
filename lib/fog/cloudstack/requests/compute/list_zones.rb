  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists zones
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listZones.html]
          def list_zones(options={})
            options.merge!(
              'command' => 'listZones'
            )
            request(options)
          end
           
        end # Real

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
        end # Mock
      end # Cloudstack
    end # Compute
  end # Fog
