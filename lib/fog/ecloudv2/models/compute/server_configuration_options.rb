require 'fog/ecloudv2/models/compute/server_configuration_option'

module Fog
  module Compute
    class Ecloudv2
      class ServerConfigurationOptions < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::ServerConfigurationOption

        def all
          data = connection.get_server_configuration_options(href).body
          load(data)
        end

        def get(uri)
          if data = connection.get_server_configuration_option(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
