require 'fog/ecloud/models/compute/environment'

module Fog
  module Compute
    class Ecloud

      class Environments < Fog::Ecloud::Collection

        model Fog::Compute::Ecloud::Environment

        undef_method :create

        identity :href

        def all
          data = []
          service.get_organization(href).body[:Locations][:Location].each do |d|
            environments = d[:Environments]
            next unless environments
            if environments[:Environment].is_a?(Array)
              environments[:Environment].each { |e| data << e }
            else
              data << environments[:Environment]
            end
          end
          load(data)
        end

        def get(uri)
          if data = service.get_environment(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

        Vdcs = Environments

      end
    end
  end
end
