require 'fog/core/collection'
require 'fog/google/models/sql/flag'

module Fog
  module Google
    class SQL
      class Flags < Fog::Collection
        model Fog::Google::SQL::Flag

        ##
        # List all available database flags
        #
        # @return [Array<Fog::Google::SQL::Flag>] List of flags
        def all
          data = service.list_flags.body['items'] || []
          load(data)
        end
      end
    end
  end
end
