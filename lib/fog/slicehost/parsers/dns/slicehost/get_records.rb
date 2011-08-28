module Fog
  module DNS
    class Slicehost
      class Real

        require 'fog/slicehost/parsers/dns/get_records'

        # Get all the DNS records across all the DNS zones for this account 
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'addresses'<~Array> - Ip addresses for the slice
        #     * 'backup-id'<~Integer> - Id of backup slice was booted from
        #     * 'flavor_id'<~Integer> - Id of flavor slice was booted from
        #     * 'id'<~Integer> - Id of the slice
        #     * 'image-id'<~Integer> - Id of image slice was booted from
        #     * 'name'<~String> - Name of the slice
        #     * 'progress'<~Integer> - Progress of current action, in percentage
        #     * 'status'<~String> - Current status of the slice
        def get_records
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::DNS::Slicehost::GetRecords.new,
            :path     => "records.xml"
          )
        end

      end
    end
  end
end
