require 'fog/ecloud/models/compute/server_configuration_option'

module Fog
  module Compute
    class Ecloud
      class ServerConfigurationOptions < Fog::Ecloud::Collection
        identity :href

        model Fog::Compute::Ecloud::ServerConfigurationOption

        def all
          data = service.get_server_configuration_options(href).body
          load(data)
        end

        def get(uri)
          if data = service.get_server_configuration_option(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
