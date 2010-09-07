require 'fog/model'

module Fog
  module Bluebox
    class Blocks

      class Image < Fog::Model

        identity :id

        attribute :description
        attribute :public
        attribute :created_at, :aliases => 'created'

      end

    end
  end
end
