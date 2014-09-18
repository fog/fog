require 'fog/core/model'

module Fog
  module DNS
    class Google
      ##
      # Resource Record Sets resource
      #
      # @see https://cloud.google.com/dns/api/v1beta1/resourceRecordSets
      class Record < Fog::Model
        identity :name

        attribute :kind
        attribute :type
        attribute :ttl
        attribute :rrdatas

      end
    end
  end
end
