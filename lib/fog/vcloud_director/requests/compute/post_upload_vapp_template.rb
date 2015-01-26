module Fog
  module Compute
    class VcloudDirector
      class Real
        # Upload an OVF package to create a vApp template
        #
        # The response includes an upload link for the OVF descriptor.
        #
        # @param [String] vdc_id Object identifier of the vDC.
        # @param [String] name The name of the vApp template.
        # @param [Hash] options
        # @option options [Boolean] :manifestRequired True if an OVF manifest
        #   is included in the upload. Default value is false.
        # @option options [String] :Description Optional description.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-UploadVAppTemplate.html
        # @since vCloud API version 0.9
        def post_upload_vapp_template(vdc_id, name, options={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              :name => name
            }
            attrs[:manifestRequired] = options[:manifestRequired] if options.key?(:manifestRequired)
            UploadVAppTemplateParams(attrs) {
              if options.key?(:Description)
                Description options[:Description]
              end
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 201,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.uploadVAppTemplateParams+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vdc/#{vdc_id}/action/uploadVAppTemplate"
          )
        end
      end
    end
  end
end
