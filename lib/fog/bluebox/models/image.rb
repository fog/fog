require 'fog/model'

module Fog
  class Bluebox

    class Image < Fog::Model

      identity :id

      attribute :description
      attribute :public
      attribute :created_at, 'created'

    end

  end
end
