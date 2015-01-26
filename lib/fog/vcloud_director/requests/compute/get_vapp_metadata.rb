module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve metadata associated with the vApp or VM.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VAppMetadata.html
        # @since vCloud API version 1.5
        def get_vapp_metadata(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/metadata/"
          )
          ensure_list! response.body, :MetadataEntry
          response
        end
      end

      class Mock

        def get_vapp_metadata(id)
          unless vm_or_vapp = data[:vapps][id] || vm_or_vapp = data[:vms][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          body = {
            :xmlns=>xmlns,
            :xmlns_xsi=>xmlns_xsi,
            :type=>"application/vnd.vmware.vcloud.metadata+xml",
            :href=>make_href("vApp/#{id}/metadata"),
            :xsi_schemaLocation=>xsi_schema_location,
            :Link=>
             [{:rel=>"up",
               :type=>"application/vnd.vmware.vcloud.vApp+xml",
               :href=>make_href("/vApp/#{id}")},
              {:rel=>"add",
               :type=>"application/vnd.vmware.vcloud.metadata+xml",
               :href=>make_href("vApp/#{id}/metadata")}],
            :MetadataEntry=>get_metadata_entries(vm_or_vapp[:metadata], id)
          }

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end

        private

        def get_metadata_entries(metadata, id)
          metadata_entries = []

          for key, value in metadata do
          metadata_entries << {:type=>"application/vnd.vmware.vcloud.metadata.value+xml",
              :href=>make_href("vApp/#{id}/metadata/#{key}"),
              :Link=>
                [{:rel=>"up",
                  :type=>"application/vnd.vmware.vcloud.metadata+xml",
                  :href=>make_href("vApp/#{id}/metadata")},
                 {:rel=>"edit",
                  :type=>"application/vnd.vmware.vcloud.metadata.value+xml",
                  :href=>make_href("vApp/#{id}/metadata/#{key}")},
                 {:rel=>"remove",
                  :href=>make_href("vApp/#{id}/metadata/#{key}")}],
              :Key=>"#{key}",
              :TypedValue=>{:xsi_type=>"MetadataStringValue", :Value=>"#{metadata[key]}"}}
          end
          metadata_entries
        end

      end
    end
  end
end
