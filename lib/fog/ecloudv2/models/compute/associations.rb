require 'fog/ecloudv2/models/compute/association'

module Fog
  module Compute
    class Ecloudv2
      class Associations < Fog::Ecloudv2::Collection

        identity :href

        model Fog::Compute::Ecloudv2::Association

        def all
          data = connection.get_associations(href).body
          if data[:Associations]
            data = data[:Associations]
            if data.is_a?(String) && data.empty?
              data = []
            elsif data.is_a?(Hash)
              data = data[:Association]
            end
          end
          load(data)
        end

        def get(uri)
          if data = connection.get_association(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
