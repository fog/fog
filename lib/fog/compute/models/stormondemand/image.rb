require 'fog/core/model'

module Fog
  module Stormondemand
    class Compute

      class Image < Fog::Model
        identity :id
        attribute :accnt
        attribute :name
        attribute :source_hostname
        attribute :source_subaccnt
        attribute :template
        attribute :template_description
        attribute :time_taken
      end

    end
  end
end
