module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :get_vdc_storage_profile_metadata, :get_vdc_storage_class_metadata

        # Retrieve metadata associated with the vDC storage profile.
        #
        # @param [String] id Object identifier of the vDC storage profile.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VdcStorageClassMetadata.html
        def get_vdc_storage_class_metadata(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vdcStorageProfile/#{id}/metadata/"
          )
        end
      end
    end
  end
end
