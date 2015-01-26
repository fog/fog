module Fog
  module Compute
    class VcloudDirector
      class Real
        # Delete an OrgVdcNetwork
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the OrgVdcNetwork.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::BadRequest]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/DELETE-Network.html
        # @since vCloud API version 0.9
        def delete_network(id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :parser  => Fog::ToHashDocument.new,
            :path    => "admin/network/#{id}"
          )
        end
      end

      class Mock
        def delete_network(id)
          unless data[:networks][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.orgVdcNetwork:#{id})\""
            )
          end

          owner = {
            :href => make_href("network/#{id}"),
            :type => 'application/vnd.vmware.vcloud.network+xml'
          }
          task_id = enqueue_task(
            "Deleting Network(#{id})", 'DeleteNetwork', owner,
            :on_success => lambda do
              data[:networks].delete(id)
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
