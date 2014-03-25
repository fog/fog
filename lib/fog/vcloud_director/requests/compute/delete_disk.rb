module Fog
  module Compute
    class VcloudDirector
      class Real
        # Delete a disk.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the disk.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/DELETE-Disk.html
        # @since vCloud API version 5.1
        def delete_disk(id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :parser  => Fog::ToHashDocument.new,
            :path    => "disk/#{id}"
          )
        end
      end

      class Mock
        def delete_disk(id)
          unless data[:disks][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.disk:#{id})\""
            )
          end

          owner = {
            :href => make_href("disk/#{id}"),
            :type => 'application/vnd.vmware.vcloud.disk+xml'
          }
          task_id = enqueue_task(
            "Deleting Disk(#{id})", 'vdcDeleteDisk', owner,
            :on_success => lambda do
              data[:disks].delete(id)
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
