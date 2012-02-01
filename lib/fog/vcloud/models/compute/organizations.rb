require 'fog/vcloud/models/compute/organization'

module Fog
  module Vcloud
    class Compute

      class Organizations < Collection

        model Fog::Vcloud::Compute::Organization

        undef_method :create

        def all
          raw_orgs = if connection.version == '1.0'
            connection.login
          else
            connection.request(connection.basic_request_params("#{connection.base_path_url}/org/"))
          end
          data = raw_orgs.body[:Org].select { |org| org[:type] == "application/vnd.vmware.vcloud.org+xml" }
          data.each { |org| org.delete_if { |key, value| [:rel].include?(key) } }
          load(data)
        end

        def get(uri)
          connection.get_organization(uri)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
