require 'fog/core/model'

module Fog
  module Rackspace
    class Databases
      class Flavor < Fog::Model
        identity :id

        attribute :name
        attribute :ram
        attribute :links
      end
    end
  end
end
