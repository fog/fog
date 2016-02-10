module Fog
  module Compute
    class VcloudDirector
      class Real
        # Delete a vApp or VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the vApp.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::BadRequest]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/DELETE-VApp.html
        # @since vCloud API version 0.9
        def delete_vapp(id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}"
          )
        end
      end
      class Mock
        def delete_vapp(id)
          unless vapp = data[:vapps][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end
          owner = {
            :href => make_href("vApp/#{id}"),
            :type => 'application/vnd.vmware.vcloud.vApp+xml'
          }
          task_id = enqueue_task(
            "Deleting Virtual Application (#{id})", 'vdcDeleteVapp', owner,
            :on_success => lambda do
              data[:vapps].delete(id)
            end
          )
          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :xsi_schemaLocation => xsi_schema_location,
          }.merge(task_body(task_id))

          Excon::Response.new(
            :status => 202,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end
      end
    end
  end
end
