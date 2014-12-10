require 'fog/core/model'

module Fog
  module Rackspace
    class Identity
      class Credential < Fog::Model
        identity :apiKey

        attribute :username
      end
    end
  end
end
