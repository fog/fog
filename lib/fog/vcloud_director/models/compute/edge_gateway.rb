require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector

      class EdgeGateway < Model

        identity  :id

        attribute :href

        attribute :name

        attribute :configuration, :aliases => :Configuration

      end
    end
  end
end
