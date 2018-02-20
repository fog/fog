module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/generators/compute/network_config_section'
        # Update the network config section of a vApp.
        #
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-NetworkConfigSection-vApp.html
        # @since vCloud API version 0.9
        def put_config_network_section_vapp(id, options={})
          body = Fog::Generators::Compute::VcloudDirector::NetworkConfigSection.new(options).generate_xml

          request(
            :body => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.networkConfigSection+xml'},
            :method => 'PUT',
            :parser => Fog::ToHashDocument.new,
            :path => "vApp/#{id}/networkConfigSection"
          )
        end
      end
    end
  end
end
