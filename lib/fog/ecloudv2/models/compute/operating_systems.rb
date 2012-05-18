require 'fog/ecloudv2/models/compute/operating_system'

module Fog
  module Compute
    class Ecloudv2
      class OperatingSystems < Fog::Ecloudv2::Collection

        model Fog::Compute::Ecloudv2::OperatingSystem

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
