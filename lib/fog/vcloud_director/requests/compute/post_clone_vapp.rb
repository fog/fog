module Fog
  module Compute
    class VcloudDirector
      class Real
        # Create a copy of a vApp.
        #
        # The response includes a Task element. You can monitor the task to to
        # track the creation of the vApp template.
        #
        # @param [String] vdc_id Object identifier of the vDC.
        # @param [String] name Name of the new vApp.
        # @param [String] source_id Object identifier of the source vApp.
        # @param [Hash] options
        # @option options [Boolean] :deploy True if the vApp should be deployed
        #   at instantiation. Defaults to true.
        # @option options [Boolean] :powerOn True if the vApp should be
        #   powered-on at instantiation. Defaults to true.
        # @option options [String] :Description Optional description.
        # @option options [Hash] :InstantiationParams Instantiation parameters
        #   for the composed vApp.
        # @option options [Boolean] :IsSourceDelete Set to true to delete the
        #   source object after the operation completes.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-CloneVApp.html
        # @since vCloud API version 0.9
        def post_clone_vapp(vdc_id, name, source_id, options={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              :name => name
            }
            attrs[:deploy] = options[:deploy] if options.key?(:deploy)
            attrs[:powerOn] = options[:powerOn] if options.key?(:powerOn)
            CloneVAppParams(attrs) {
              if options.key?(:Description)
                Description options[:Description]
              end
              InstantiationParams {
                # TODO
              }
              Source(:href => "#{end_point}vApp/#{source_id}")
              if options.key?(:IsSourceDelete)
                IsSourceDelete options[:IsSourceDelete]
              end
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 201,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.cloneVAppParams+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vdc/#{vdc_id}/action/cloneVApp"
          )
        end
      end
    end
  end
end
