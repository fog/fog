require 'fog/core/model'

module Fog
  module Compute
    class Slicehost

      class Image < Fog::Model

        identity :id

        attribute :name

      end

    end
  end
end
