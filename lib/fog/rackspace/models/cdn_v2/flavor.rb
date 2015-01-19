require 'fog/core/model'

module Fog
  module Rackspace
    class CDNV2 < Fog::Service
      class Flavor < Fog::Model
        identity :id

        attribute :providers
        attribute :links
      end
    end
  end
end
