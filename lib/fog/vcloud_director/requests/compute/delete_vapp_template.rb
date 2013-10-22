module Fog
  module Compute
    class VcloudDirector
      class Real
        # Delete a vApp template.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the vApp template.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/DELETE-VAppTemplate.html
        # @since vCloud API version 0.9
        def delete_vapp_template(id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vAppTemplate/#{id}"
          )
        end
      end
    end
  end
end
