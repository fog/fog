module Fog
  module Compute
    class Cloudstack
      class Real

        # Copies a template from one zone to another
        #
        # ==== Parameters
        # * id<~Integer>: Template ID
        # * destZoneId<~Integer>: ID of the zone the template is being copied to
        # * sourceZoneId<~Integer>: ID of the zone the template is currently hosted on
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/copyTemplate.html]
        def copy_template(id, destZoneId, sourceZoneId)
          params = {
            'command'       => 'copyTemplate',
            'id'            => id,
            'destzoneid'    => destZoneId,
            'sourcezoneid'  => sourceZoneId
          }

          request(params)
        end
      end

      class Mock
        def copy_template(id, destZoneId, sourceZoneId)
          {"copytemplateresponse"=>{"jobid"=>171}}
        end
      end
    end
  end
end