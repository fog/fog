require 'fog/vcloud/models/compute/vapp'

module Fog
  module Vcloud
    class Compute

      class Vapps < Collection

        model Fog::Vcloud::Compute::Vapp

        undef_method :create

        attribute :href

        def all
          load([connection.get_vdc(self.href).resource_entities].flatten.select { |re| re[:type] == "application/vnd.vmware.vcloud.vApp+xml" })
        end

        def get(uri)
          connection.get_vapp(uri)
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
