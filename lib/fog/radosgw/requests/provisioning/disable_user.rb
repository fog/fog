module Fog
  module Radosgw
    class Provisioning
      class Real
        include Utils
        include UserUtils
        include MultipartUtils

        def disable_user(user_id)
          update_radosgw_user(user_id, { :suspended => 1 })
        end
      end

      class Mock
        include UserUtils

        def disable_user(user_id)
          update_mock_user(user_id, { :suspended => 1 })
        end
      end
    end
  end
end
