module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :put_metadata_value, :put_vapp_metadata_item_metadata

        # Set the value for the specified metadata key to the value provided,
        # overwriting any existing value.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @param [String] key Key of the metadata item.
        # @param [String] value Value of the metadata item.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-VAppMetadataItem-metadata.html
        #   vCloud API Documentation
        # @since vCloud API version 1.5
        def put_vapp_metadata_item_metadata(id, key, value)
          body = Nokogiri::XML::Builder.new do
            MetadataValue {
              Value value
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => "application/vnd.vmware.vcloud.metadata.value+xml"},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/metadata/#{URI.escape(key)}"
          )
        end
      end
    end
  end
end
