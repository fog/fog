module Fog
  module Vcloud
    class Compute
      class Catalogs < Fog::Vcloud::Collection

        model Fog::Vcloud::Compute::Catalog

        def all
          data = connection.get_organization(organization_uri).body[:Link].select { |link| link[:type] == "application/vnd.vmware.vcloud.catalog+xml" }
          load(data)
        end

        def get(uri)
          if data = connection.get_catalog(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def organization_uri
          @organization_uri ||= connection.default_organization_uri
        end

      end
    end
  end
end
