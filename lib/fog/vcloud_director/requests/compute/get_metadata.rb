module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve metadata associated with the vApp or VM.
        #
        # @deprecated Use {#get_vapp_metadata} instead.
        # @todo Log deprecation warning.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VAppMetadata.html
        # @since vCloud API version 1.5
        def get_metadata(id)
          require 'fog/vcloud_director/parsers/compute/metadata'

          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Compute::VcloudDirector::Metadata.new,
            :path       => "vApp/#{id}/metadata/"
          )
        end
      end
      class Mock
        def get_metadata(id)
          tags = data[:tags][id] || {}
          body = {:type => 'application/vnd.vmware.vcloud.metadata+xml', :metadata => tags}
          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end
      end
    end
  end
end
