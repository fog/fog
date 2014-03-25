module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the operating system section of a VM.
        #
        # @param [String] id The object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-OperatingSystemSection.html
        # @since vCloud API version 0.9
        def get_operating_system_section(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/operatingSystemSection/"
          )
        end
      end
    end
  end
end
