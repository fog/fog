module Fog
  module Radosgw
    class Provisioning
      class Real
        include Utils
        include UserUtils
        include MultipartUtils

        def enable_user(key_id)
          update_radosgw_user(key_id, { :status => 'enabled' })
        end
      end

      class Mock
        include UserUtils

        def enable_user(key_id)
          update_mock_user(key_id, { :status => 'enabled' })
        end
      end
    end
  end
end
