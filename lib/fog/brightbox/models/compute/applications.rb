require 'fog/core/collection'
require 'fog/brightbox/models/compute/application'

module Fog
  module Compute
    class Brightbox

      class Applications < Fog::Collection

        model Fog::Compute::Brightbox::Application

        def all
          data = connection.list_applications
          load(data)
        end

        def get(identifier)
          data = connection.get_application(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end