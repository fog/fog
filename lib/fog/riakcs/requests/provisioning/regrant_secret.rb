module Fog
  module RiakCS
    class Provisioning
      class Real
        include Utils
        include UserUtils
        include MultipartUtils

        def regrant_secret(key_id)
          update_riakcs_user(key_id, { :new_key_secret => true })
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
