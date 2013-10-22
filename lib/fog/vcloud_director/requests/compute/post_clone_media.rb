module Fog
  module Compute
    class VcloudDirector
      class Real
        # Create a copy of a media object.
        #
        # The response includes a Task element. You can monitor the task to to
        # track the creation of the vApp template.
        #
        # @param [String] vdc_id Object identifier of the vDC.
        # @param [String] source_id Object identifier of the source media
        #   object.
        # @param [Hash] options
        # @option options [String] :Description Optional description.
        # @option options [Boolean] :IsSourceDelete A value of true deletes the
        #   Source object after successful completion of the copy operation.
        #   Defaults to false if empty or missing.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-CloneMedia.html
        # @since vCloud API version 0.9
        def post_clone_media(vdc_id, source_id, options={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5'
            }
            CloneMediaParams(attrs) {
              if options.key?(:Description)
                Description options[:Description]
              end
              Source(:href => "#{end_point}media/#{source_id}")
              if options.key?(:IsSourceDelete)
                IsSourceDelete options[:IsSourceDelete]
              end
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 201,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.cloneMediaParams+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vdc/#{vdc_id}/action/cloneMedia"
          )
        end
      end
    end
  end
end
