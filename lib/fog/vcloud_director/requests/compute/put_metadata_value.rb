module Fog
  module Compute
    class VcloudDirector
      class Real
        # Set the value for the specified metadata key to the value provided,
        # overwriting any existing value.
        #
        # @param [String] vm_id
        # @param [String] metadata_key
        # @param [String] metadata_value
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-VAppMetadataItem-metadata.html
        #   vCloud API Documentation
        def put_metadata_value(vm_id, metadata_key, metadata_value)
          body="
          <MetadataValue xmlns=\"http://www.vmware.com/vcloud/v1.5\">
              <Value>#{metadata_value}</Value>
           </MetadataValue>"

          request(
            :body    => body,
            :expects => 202,
            :headers => { 'Content-Type' => "application/vnd.vmware.vcloud.metadata.value+xml" },
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{vm_id}/metadata/#{URI.escape(metadata_key)}"
          )
        end
      end
    end
  end
end
