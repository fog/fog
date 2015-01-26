module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/generators/compute/vapp'

        # Modify the name or description of a vApp.
        #
        # This operation is asynchronous and returns a task that you can monitor
        # to track the progress of the request.
        #
        #
        # @param [String] id Object identifier of the vApp.
        # @param [String] name of the vApp.
        # @param [Hash] options
        #   * :Description<~String>: - description to be assigned (optional)
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-55/topic/com.vmware.vcloud.api.reference.doc_55/doc/operations/PUT-VAppNameAndDescription.html
        # @since vCloud API version 0.9
        def put_vapp_name_and_description(id, name, options={})
          body = Fog::Generators::Compute::VcloudDirector::Vapp.new(name, options).generate_xml
          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.vApp+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}"
          )
        end
      end
    end
  end
end
