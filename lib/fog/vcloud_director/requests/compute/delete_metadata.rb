module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/metadata'

        # Delete the specified key and its value from vApp or VM metadata.
        #
        # @param [String] vm_id
        # @param [String] metadata_key
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VAppMetadataItem-metadata.html
        #   vCloud API Documentation
        # @since vCloud API version 1.5
        def delete_metadata(vm_id, metadata_key)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{vm_id}/metadata/#{URI.escape(metadata_key)}"
          )
        end
      end
    end
  end
end
