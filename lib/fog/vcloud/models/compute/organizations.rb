require 'fog/vcloud/models/compute/organization'

module Fog
  module Vcloud
    class Compute

      class Organizations < Collection

        model Fog::Vcloud::Compute::Organization

        undef_method :create

        def all
          data = connection.login.body[:Org].select { |org| org[:type] == "application/vnd.vmware.vcloud.org+xml" }
          data.each { |org| org.delete_if { |key, value| [:rel].include?(key) } }
          load(data)
        end

        def get(uri)
          if data = connection.get_organization(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
