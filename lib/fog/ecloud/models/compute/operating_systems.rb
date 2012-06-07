require 'fog/ecloud/models/compute/operating_system'

module Fog
  module Compute
    class Ecloud
      class OperatingSystems < Fog::Ecloud::Collection

        model Fog::Compute::Ecloud::OperatingSystem

        identity :data

        def all
          load(data)
        end

        def get(uri)
          if data = connection.get_operating_system(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
