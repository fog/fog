module Fog
  module Compute
    class VcloudDirector
      class Real
        # Merge the metadata provided in the request with existing metadata.
        #
        # @param [String] id Object identifier of the media object.
        # @param [Hash{String=>Boolean,DateTime,Fixnum,String}] metadata
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-UpdateMediaMetadata.html
        # @since vCloud API version 1.5
        def post_update_media_metadata(id, metadata={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            }
            Metadata(attrs) {
              metadata.each do |key, value|
                MetadataEntry {
                  Key key
                  if api_version.to_f < 5.1
                    Value value
                  else
                    type = case value
                           when TrueClass, FalseClass then 'MetadataBooleanValue';
                           when DateTime then 'MetadataDateTimeValue';
                           when Fixnum then 'MetadataNumberValue';
                           else 'MetadataStringValue'
                           end
                    TypedValue('xsi:type' => type) { Value value }
                  end
                }
              end
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.metadata+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "media/#{id}/metadata/"
          )
        end
      end
    end
  end
end
