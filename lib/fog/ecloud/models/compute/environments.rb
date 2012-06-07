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
          connection.get_organization(href).body[:Locations][:Location].each do |d| 
            if d[:Environments][:Environment].is_a?(Array)
              d[:Environments][:Environment].each { |e| data << e }
            else
              data << d[:Environments][:Environment]
            end
          end
          load(data)
        end

        def get(uri)
          if data = connection.get_environment(uri)
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
