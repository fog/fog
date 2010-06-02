module Fog
  module Bluebox
    class Real

      require 'fog/bluebox/parsers/create_block'

      # Get list of slices
      # ==== Parameters
      # * flavor_id<~Integer> - Id of flavor to create slice with
      # * image_id<~Integer> - Id of image to create slice with
      # * name<~String> - Name of slice
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      #     * 'addresses'<~Array> - Ip addresses for the slice
      #     * 'backup-id'<~Integer> - Id of backup slice was booted from
      #     * 'bw-in'<~Integer> - Incoming bandwidth total for current billing cycle, in Gigabytes
      #     * 'bw-out'<~Integer> - Outgoing bandwidth total for current billing cycle, in Gigabytes
      #     * 'flavor-id'<~Integer> - Id of flavor slice was booted from
      #     * 'id'<~Integer> - Id of the slice
      #     * 'image-id'<~Integer> - Id of image slice was booted from
      #     * 'name'<~String> - Name of the slice
      #     * 'progress'<~Integer> - Progress of current action, in percentage
      #     * 'root-password'<~String> - Root password of slice
      #     * 'status'<~String> - Current status of the slice
      def create_block(flavor_id, image_id, name, password)
        response = request(
          :body     => %Q{<?xml version="1.0" encoding="UTF-8"?><block><product type="string">#{flavor_id}</product><template type="string">#{image_id}</template><name>#{name}</name><password>#{password}</password></block>}, # ["template=#{image_id}","product=#{flavor_id}"].join("\n"),
          :expects  => [200, 409],
          :method   => 'POST',
          :parser   => Fog::Parsers::Bluebox::CreateBlock.new,
          :path     => '/api/blocks.xml'
        )

        response
      end

    end

    class Mock

      def create_block(flavor_id, image_id, name, password)
        Fog::Mock.not_implemented
      end

    end
  end
end
