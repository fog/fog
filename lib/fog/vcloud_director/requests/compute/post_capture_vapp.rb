module Fog
  module Compute
    class VcloudDirector
      class Real
        # Create a vApp template from a vApp.
        #
        # The response includes a Task element. You can monitor the task to to
        # track the creation of the vApp template.
        #
        # @param [String] vdc_id Object identifier of the vDC.
        # @param [String] name Name of the vApp template.
        # @param [String] source_id Object identifier of the vApp to capture.
        # @param [Hash] options
        # @option options [String] :Description Optional description.
        # @option options [Hash] :LeaseSettingsSection
        #   * :StorageLeaseInSeconds<~Integer> - Storage lease in seconds.
        # @option options [Hash] :CustomizationSection
        #   * :goldMaster<~Boolean> - True if this template is a gold master.
        #   * :CustomizeOnInstantiate<~Boolean> - True if instantiating this
        #     template applies customization settings. Otherwise, instantiation
        #     creates an identical copy.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-CaptureVApp.html
        # @since vCloud API version 0.9
        def post_capture_vapp(vdc_id, name, source_id, options={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              'xmlns:ovf' => 'http://schemas.dmtf.org/ovf/envelope/1',
              :name => name
            }
            CaptureVAppParams(attrs) {
              if options.key?(:Description)
                Description options[:Description]
              end
              Source(:href => "#{end_point}vApp/#{source_id}")
              if section = options[:LeaseSettingsSection]
                LeaseSettingsSection {
                  self['ovf'].Info 'Lease settings section'
                  if section.key?(:StorageLeaseInSeconds)
                    StorageLeaseInSeconds section[:StorageLeaseInSeconds]
                  end
                }
              end
              if section = options[:CustomizationSection]
                attrs = {}
                attrs[:goldMaster] = section[:goldMaster] if section.key?(:goldMaster)
                CustomizationSection(attrs) {
                  self['ovf'].Info 'VApp template customization section'
                  CustomizeOnInstantiate section[:CustomizeOnInstantiate]
                }
              end
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 201,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.captureVAppParams+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vdc/#{vdc_id}/action/captureVApp"
          )
        end
      end
    end
  end
end
