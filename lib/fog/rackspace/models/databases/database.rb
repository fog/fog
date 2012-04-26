require 'fog/core/model'

module Fog
  module Rackspace
    class Databases
      class Database < Fog::Model
        identity :name
      end
    end
  end
end
