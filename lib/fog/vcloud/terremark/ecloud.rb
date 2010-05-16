module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Versions
          SUPPORTED = ["v0.8", "v0.8a-ext2.0"]
        end

        def self.extended(klass)
          #Do anything we need to do here that's specific to ecloud
          unless @required
            require 'fog/vcloud/terremark/all'
            require 'fog/vcloud/terremark/ecloud/models/vdc'
            require 'fog/vcloud/terremark/ecloud/models/vdcs'
            require 'fog/vcloud/terremark/ecloud/parsers/get_vdc'
            require 'fog/vcloud/terremark/ecloud/requests/login'
            require 'fog/vcloud/terremark/ecloud/requests/get_vdc'
            Struct.new("TmrkEcloudVdc", :links, :resource_entities, :networks,
                       :cpu_capacity, :storage_capacity, :memory_capacity, :deployed_vm_quota, :instantiated_vm_quota,
                       :href, :type, :name, :xmlns, :description)
            @required = true
          end
          if Fog.mocking?
            klass.extend Fog::Vcloud::Terremark::Ecloud::Mock
          else
            klass.extend Fog::Vcloud::Terremark::Ecloud::Real
          end
        end

        private

        # If we don't support any versions the service does, then raise an error.
        # If the @version that super selected isn't in our supported list, then select one that is.
        def check_versions
          super
          unless (supported_version_ids & Versions::SUPPORTED).length > 0
            raise UnsupportedVersion.new("\nService @ #{@versions_uri} supports: #{supported_version_ids.join(', ')}\n" +
                                         "Fog::Vcloud::Terremark::Ecloud supports: #{Versions::SUPPORTED.join(', ')}")
          end
          unless supported_version_ids.include?(@version)
            @version = (supported_version_ids & Versions::SUPPORTED).sort.first
          end
        end
      end
    end
  end
end
