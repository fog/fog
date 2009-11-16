module Fog
  module Rackspace
    class Servers

      def flavors
        Fog::Rackspace::Servers::Flavors.new(:connection => self)
      end

      class Flavors < Fog::Collection

        model Fog::Rackspace::Servers::Flavor

        def all
          data = connection.list_flavors_detail.body
          flavors = Fog::Rackspace::Servers::Flavors.new({
            :connection => connection
          })
          for flavor in data['flavors']
            flavors << Fog::Rackspace::Servers::Flavor.new({
              :collection => flavors,
              :connection => connection
            }.merge!(flavor))
          end
          flavors
        end

        def get(flavor_id)
          connection.get_flavor_details(flavor_id)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
