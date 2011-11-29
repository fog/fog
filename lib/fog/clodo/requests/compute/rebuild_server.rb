module Fog
  module Compute
    class Clodo
      class Real
        def rebuild_server(id, image_id, vps_isp = nil)
          body = {'rebuild' => {'imageId' => image_id}}
          body['rebuild']['vps_isp'] = vps_isp if vps_isp
          server_action(id, body)
        end
      end

      class Mock
        def rebuild_server(id, image_id, vps_isp = nil)
          body = {'rebuild' => {'imageId' => image_id}}
          body['rebuild']['vps_isp'] = vps_isp if vps_isp
          server_action(id, body)
        end
      end
    end
  end
end
