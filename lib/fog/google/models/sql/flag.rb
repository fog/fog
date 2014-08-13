require 'fog/core/model'

module Fog
  module Google
    class SQL
      ##
      # A Google Cloud SQL service flag resource
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/flags
      class Flag < Fog::Model
        identity :name

        attribute :allowed_string_values, :aliases => 'allowedStringValues'
        attribute :applies_to, :aliases => 'appliesTo'
        attribute :kind
        attribute :max_value, :aliases => 'maxValue'
        attribute :min_value, :aliases => 'minValue'
        attribute :type
      end
    end
  end
end
