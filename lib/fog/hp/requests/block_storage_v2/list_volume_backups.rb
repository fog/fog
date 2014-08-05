module Fog
  module HP
    class BlockStorageV2
      class Real
        # List existing block storage volume backups
        #
        # ==== Parameters
        # * options<~Hash>: filter options
        #   * 'name'<~String> - Name of the volume
        #   * 'marker'<~String> - The ID of the last item in the previous list
        #   * 'limit'<~Integer> - Sets the page size
        #   * 'changes-since'<~DateTime> - Filters by the changes-since time. The list contains servers that have been deleted since the changes-since time.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * backups<~Hash>:
        #       * 'id'<~String> - UUId for the volume backup
        #       * 'name'<~String> - Name of the volume backup
        #       * 'links'<~Array> - array of volume backup links
        def list_volume_backups(options = {})
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'backups',
            :query    => options
          )
          response
        end
      end

      class Mock # :nodoc:all
        def list_volume_backups(options = {})
          response = Excon::Response.new
          backups = []
          data = list_volume_backups_detail.body['backups']
          for backup in data
            backups << backup.reject { |key, _| !['id', 'name', 'links'].include?(key) }
          end

          response.status = 200
          response.body = { 'backups' => backups }
          response
        end
      end
    end
  end
end
