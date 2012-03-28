module Fog
  module RiakCS
    class Provisioning
      class Real
        include Utils
        include UserUtils
        include MultipartUtils

        def update_user(key_id, user)
          update_riakcs_user(key_id, user)
        end
      end

      class Mock
        include UserUtils

        def update_user(key_id, user)
          update_mock_user(key_id, user)
        end
      end
    end
  end
end
