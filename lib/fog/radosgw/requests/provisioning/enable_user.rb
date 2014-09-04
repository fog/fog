module Fog
  module Radosgw
    class Provisioning
      class Real
        include Utils
        include UserUtils
        include MultipartUtils

        def enable_user(user_id)
          update_radosgw_user(user_id, { :suspended => 0 })
        end
      end

      class Mock
        include UserUtils

        def enable_user(user_id)
          update_mock_user(user_id, { :suspended => 0 })
        end
      end
    end
  end
end
