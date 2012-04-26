require 'fog/core/model'

module Fog
  module Rackspace
    class Databases
      class User < Fog::Model
        identity :name
      end
    end
  end
end
