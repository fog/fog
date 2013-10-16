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
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-CaptureVApp.html
        # @since vCloud API version 0.9
        def post_capture_vapp(vdc_id, name, source_id, options={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              :name => name
            }
            CaptureVAppParams(attrs) {
              if options.key?(:Description)
                Description options[:Description]
              end
              Source(:href => "#{end_point}vApp/#{source_id}")
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
