require 'fog/core/collection'
require 'fog/google/models/sql/tier'

module Fog
  module Google
    class SQL
      class Tiers < Fog::Collection
        model Fog::Google::SQL::Tier

        ##
        # Lists all available service tiers
        #
        # @return [Array<Fog::Google::SQL::Tier>] List of tiers
        def all
          data = service.list_tiers.body['items'] || []
          load(data)
        end
      end
    end
  end
end
