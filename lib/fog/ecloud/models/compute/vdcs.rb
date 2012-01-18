require 'fog/ecloud/models/compute/vdc'

module Fog
  module Compute
    class Ecloud

      class Vdcs < Collection

        model Fog::Compute::Ecloud::Vdc

        undef_method :create

        def all
          data = connection.get_organization(organization_uri).body[:Link].select { |link| link[:type] == "application/vnd.vmware.vcloud.vdc+xml" }
          data.each { |link| link.delete_if { |key, value| [:rel].include?(key) } }
          load(data)
        end

        def get(uri)
          if data = connection.get_vdc(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def organization_uri
          @organizatio_uri ||= connection.default_organization_uri
        end

        private

        def organization_uri=(new_organization_uri)
          @organization_uri = new_organization_uri
        end

      end
    end
  end
end
