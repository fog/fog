require 'fog/core/model'

module Fog
  module Google
    class SQL
      ##
      # A Google Cloud SQL service tier resource
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/tiers
      class Tier < Fog::Model
        identity :tier

        attribute :disk_quota, :aliases => 'DiskQuota'
        attribute :kind
        attribute :ram, :aliases => 'RAM'
        attribute :region
      end
    end
  end
end
