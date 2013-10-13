module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the value of the specified key from virtual datacenter
        # metadata.
        #
        # @param [String] id Object identifier of the network.
        # @param [String] domain
        # @param [String] key Key of the metadata.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VdcMetadataItem-metadata.html
        # @since vCloud API version 1.5
        def get_vdc_metadata_item_metadata(id, domain, key)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "admin/vdc/#{id}/metadata/#{URI.escape(key)})"
          )
        end
      end
    end
  end
end
