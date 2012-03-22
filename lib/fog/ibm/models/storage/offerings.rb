require 'fog/core/collection'
require 'fog/ibm/models/storage/offering'

module Fog
  module Storage
    class IBM

      class Offerings < Fog::Collection

        model Fog::Storage::IBM::Offering

        def all
          load(connection.list_offerings.body['volumes'])
        end

      end
    end
  end
end
