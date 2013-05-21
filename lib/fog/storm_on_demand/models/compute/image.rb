require 'fog/core/model'

module Fog
  module Compute
    class StormOnDemand

      class Image < Fog::Model
        identity :id
        attribute :accnt
        attribute :features
        attribute :hv_type
        attribute :name
        attribute :source_hostname
        attribute :source_uniq_id
        attribute :template
        attribute :template_description
        attribute :time_taken
      end

    end
  end
end
