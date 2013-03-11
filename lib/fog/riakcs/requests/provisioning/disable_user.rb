module Fog
  module RiakCS
    class Provisioning
      class Real
        include Utils
        include UserUtils
        include MultipartUtils

        def disable_user(key_id)
          update_riakcs_user(key_id, { :status => 'disabled' })
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
