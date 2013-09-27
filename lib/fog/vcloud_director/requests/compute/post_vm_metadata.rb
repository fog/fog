module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/generators/compute/metadata'

        # Merge the metadata provided in the request with existing metadata.
        #
        # @param [String] vm_id
        # @param [Hash{String=>String}] metadata
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-UpdateVAppMetadata.html
        #   vCloud API Documentation
        def post_vm_metadata(vm_id, metadata={})
          metadata_klass = case api_version
                           when '5.1' ; Fog::Generators::Compute::VcloudDirector::MetadataV51
                           when '1.5' ; Fog::Generators::Compute::VcloudDirector::MetadataV15
                           else raise "API version: #{api_version} not supported"
                           end
          data = metadata_klass.new(metadata)

          request(
            :body    => data.generate_xml,
            :expects => 202,
            :headers => { 'Content-Type' => "application/vnd.vmware.vcloud.metadata+xml" },
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{vm_id}/metadata/"
          )
        end
      end
    end
  end
end
