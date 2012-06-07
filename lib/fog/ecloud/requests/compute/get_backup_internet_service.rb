module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_backup_internet_service
      end

      class Mock
        def get_backup_internet_service(uri)
        end
      end
    end
  end
end
