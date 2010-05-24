require 'fog/model'

module Fog
  module Bluebox

    class Template < Fog::Model

      identity :id

      attribute :description
      attribute :public
      attribute :created_at, 'created'

    end

  end
end
