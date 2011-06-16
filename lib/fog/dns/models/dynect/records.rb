require 'fog/core/collection'
require 'fog/dns/models/dynect/record'

module Fog
  module Dynect
    class DNS

      class Records < Fog::Collection

        attribute :zone

        model Fog::Dynect::DNS::Record

        def all
        end

        def get(record_id)
        end

        def new(attributes = {})
        end

      end

    end
  end
end
