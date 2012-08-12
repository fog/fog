require 'fog/core/collection'
require 'fog/terremark/models/shared/internetservice'

module Fog
  module Terremark
    module Shared

      module Mock
        def internetservices(options = {})
          Fog::Terremark::Shared::Servers.new(options.merge(:connection => self))
        end
      end

      module Real
        def internetservices(options = {})
          Fog::Terremark::Shared::InternetServices.new(options.merge(:connection => self))
        end
      end

      class InternetServices < Fog::Collection

        model Fog::Terremark::Shared::InternetService

        def all
          data = connection.get_internet_services(vdc_id).body["InternetServices"]
          load(data)
        end

        def get(service_id)
          data = connection.get_internet_services(vdc_id)
          internet_service = services.body["InternetServices"].select {|item| item["Id"] == service_id}
          new(internetservice)
        end

        def vdc_id
          @vdc_id ||= connection.default_vdc_id
        end

      end
    end
  end
end
