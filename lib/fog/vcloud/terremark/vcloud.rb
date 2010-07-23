module Fog
  module Vcloud
    module Terremark
      module Vcloud
        extend Fog::Vcloud::Extension

        request_path 'fog/vcloud/terremark/vcloud/requests'
        request :get_vdc

        module Real
          def supporting_versions
            ["0.8", "0.8a-ext1.6"]
          end
        end
      end
    end
  end
end
