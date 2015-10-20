module Fog
  module Compute
    class DigitalOceanV2
      class Image < Fog::Model
        identity :id
        attribute :name
        attribute :type
        attribute :distribution
        attribute :slug
        attribute :public
        attribute :regions
        attribute :min_disk_size
        attribute :created_at
      end

      def transfer
        perform_action :transfer_image
      end

      def convert_to_snapshot
        perform_action :convert_image_to_snapshot
      end
    end
  end
end