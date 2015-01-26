module Fog
  module Compute
    class VcloudDirector
      class Real
        # Create a copy of a vApp template.
        #
        # The response includes a Task element. You can monitor the task to to
        # track the creation of the vApp template.
        #
        # @param [String] vdc_id Object identifier of the vDC.
        # @param [String] name Name of the new vApp template.
        # @param [String] source_id Object identifier of the source vApp
        #   template.
        # @param [Hash] options
        # @option options [String] :Description Optional description.
        # @option options [Boolean] :IsSourceDelete Set to true to delete the
        #   source object after the operation completes.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-CloneVAppTemplate.html
        # @since vCloud API version 0.9
        def post_clone_vapp_template(vdc_id, name, source_id, options={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              :name => name
            }
            CloneVAppTemplateParams(attrs) {
              if options.key?(:Description)
                Description options[:Description]
              end
              Source(:href => "#{end_point}vAppTemplate/#{source_id}")
              if options.key?(:IsSourceDelete)
                IsSourceDelete options[:IsSourceDelete]
              end
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 201,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.cloneVAppTemplateParams+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vdc/#{vdc_id}/action/cloneVAppTemplate"
          )
        end
      end
    end
  end
end
