module Fog
  module Vcloud
    module Terremark
      module Vcloud
        extend Fog::Vcloud::Extension

        versions "v0.8"

        request_path 'fog/vcloud/terremark/vcloud/requests'
        request :get_vdc

        private

        # If we don't support any versions the service does, then raise an error.
        # If the @version that super selected isn't in our supported list, then select one that is.
        def check_versions
          super
          unless (supported_version_ids & Versions::SUPPORTED).length > 0
            raise UnsupportedVersion.new("\nService @ #{@versions_uri} supports: #{supported_version_ids.join(', ')}\n" +
                                         "Fog::Vcloud::Terremark::Vcloud supports: #{Versions::SUPPORTED.join(', ')}")
          end
          unless supported_version_ids.include?(@version)
            @version = (supported_version_ids & Versions::SUPPORTED).sort.first
          end
        end
      end
    end
  end
end
