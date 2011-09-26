require 'fog/vcloud/models/compute/vapp'

module Fog
  module Vcloud
    class Compute

      class Vapps < Collection

        model Fog::Vcloud::Compute::Vapp

        undef_method :create
        
        attribute :href

        def all
          data = connection.get_vdc(self.href).body[:ResourceEntities][:ResourceEntity].select { |re| re[:type] == "application/vnd.vmware.vcloud.vApp+xml" }
          load(data)
        end

        def get(uri)
          if data = connection.get_vapp(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
