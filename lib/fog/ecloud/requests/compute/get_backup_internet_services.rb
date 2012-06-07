module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_backup_internet_services
      end

      class Mock
        def get_backup_internet_services(uri)
        end
      end
    end
  end
end
