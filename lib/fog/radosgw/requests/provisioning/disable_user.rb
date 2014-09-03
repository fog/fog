module Fog
  module Radosgw
    class Provisioning
      class Real
        include Utils
        include UserUtils
        include MultipartUtils

        def disable_user(key_id)
          update_radosgw_user(key_id, { :status => 'disabled' })
        end
      end

      class Mock
        include UserUtils

        def disable_user(key_id)
          update_mock_user(key_id, { :status => 'disabled' })
        end
      end
    end
  end
end
