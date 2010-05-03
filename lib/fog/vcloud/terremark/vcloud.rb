module Fog
  module Vcloud
    module Terremark
      module Vcloud

        module Versions
          SUPPORTED = ["v0.8"]
        end

        def self.extended(klass)
          #Do anything we need to do here that's specific to ecloud
          unless @required
            require 'fog/vcloud/terremark/all'
            require 'fog/vcloud/terremark/vcloud/parsers/get_vdc'
            require 'fog/vcloud/terremark/vcloud/requests/get_vdc'
            Struct.new("TmrkVcloudVdc", :links, :resource_entities, :networks, :href, :type, :name, :xmlns)
            @required = true
          end
          if Fog.mocking?
            klass.extend Fog::Vcloud::Terremark::Vcloud::Mock
          else
            klass.extend Fog::Vcloud::Terremark::Vcloud::Real
          end
        end

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
