module Fog
  module Radosgw
    class Provisioning
      class Real
        include Utils
        include UserUtils
        include MultipartUtils

        def regrant_secret(key_id)
          update_radosgw_user(key_id, { :new_key_secret => true })
        end
      end

      class Mock
        include UserUtils

        def regrant_secret(key_id)
          update_mock_user(key_id, { :new_key_secret => true })
        end
      end
    end
  end
end
