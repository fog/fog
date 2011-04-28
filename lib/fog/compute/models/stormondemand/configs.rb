require 'fog/core/collection'
require 'fog/compute/models/stormondemand/config'

module Fog
  module Stormondemand
    class Compute

      class Configs < Fog::Collection

        model Fog::Stormondemand::Compute::Config

        def all
          data = connection.list_configs.body['configs']
          load(data)
        end


      end

    end
  end
end
