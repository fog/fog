module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve SnapshotSection element for a vApp or VM.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-SnapshotSection.html
        # @since vCloud API version 5.1
        def get_snapshot_section(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/snapshotSection"
          )
        end
      end

      class Mock

        def get_snapshot_section(id)
          type = 'application/vnd.vmware.vcloud.snapshotSection+xml'

          unless data[:vms][id] || data[:vapps][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{type};version=#{api_version}"},
            :body => get_snapshot_section_body(id)
          )
        end

        def get_snapshot_section_body(id)
          {
            :type => "application/vnd.vmware.vcloud.snapshotSection+xml",
            :href => make_href("vApp/#{id}/snapshotSection"),
            :ovf_required => "false",
            :"ovf:Info"   => "Snapshot information section"
          }
        end

      end

    end
  end
end
