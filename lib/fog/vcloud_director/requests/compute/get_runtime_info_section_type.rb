module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the runtime info section of a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-RuntimeInfoSectionType.html
        # @since vCloud API version 1.5
        def get_runtime_info_section_type(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/runtimeInfoSection"
          )
        end
      end
    end
  end
end
