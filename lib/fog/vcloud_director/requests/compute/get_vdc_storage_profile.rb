module Fog
  module Compute
    class VcloudDirector
      class Real
        # Returns storage class referred by the Id. All properties of the
        # storage classes are visible to vcloud user, except for VDC Storage
        # Class reference.
        #
        # @param [String] id Object identifier of the vDC storage profile.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VdcStorageClass.html
        #   vCloud API Documentation
        def get_vdc_storage_profile(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vdcStorageProfile/#{id}"
          )
        end
      end
    end
  end
end
