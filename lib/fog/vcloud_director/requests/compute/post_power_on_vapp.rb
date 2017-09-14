module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :post_vm_poweron, :post_power_on_vapp

        # Power on a vApp or VM.
        #
        # If used on a vApp, powers on all VMs in the vApp. If used on a VM,
        # powers on the VM. This operation is available only for a vApp or VM
        # that is powered off.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::BadRequest]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-PowerOnVApp.html
        # @since vCloud API version 0.9
        def post_power_on_vapp(id)
          request(
            :expects => 202,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/power/action/powerOn"
          )
        end
      end
      class Mock
        def post_power_on_vapp(id)
          unless vapp = data[:vapps][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end
          
          owner = {
            :href => make_href("vApp/#{id}"),
            :type => 'application/vnd.vmware.vcloud.vApp+xml'
          }
          task_id = enqueue_task(
            "Starting Virtual Application #{data[:vapps][id]} vapp(#{id})", 'vappDeploy', owner,
            :on_success => lambda do
              data[:vms].values.each do |vm|
                if vm[:parent_vapp] == id
                  vm[:status] = '4' # on
                end
              end
            end
          )
          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :xsi_schemaLocation => xsi_schema_location,
          }.merge(task_body(task_id))

          Excon::Response.new(
            :status => 202,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end
      end
    end
  end
end
