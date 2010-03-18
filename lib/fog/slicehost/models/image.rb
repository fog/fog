require 'fog/model'

module Fog
  module Slicehost

    class Image < Fog::Model

      identity :id

      attribute :name

    end

  end
end
