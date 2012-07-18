module Fog
  module Compute
    class Cloudstack
      class Real

        # Updates account information for the authenticated user.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/destroyVirtualMachine.html]
        def destroy_virtual_machine(options={})
          options.merge!(
            'command' => 'destroyVirtualMachine'
          )

          request(options)
        end

      end # Real

      class Mock

        def destroy_virtual_machine(options={})
          identity = options["id"]

          server = self.data[:servers][identity]
          unless server
            raise Fog::Compute::Cloudstack::BadRequest.new("Unable to execute API command attachserver due to invalid value. Object servers(uuid: #{identity}) does not exist.")
          end

          job_id = Fog::Cloudstack.uuid

          job = {
            "cmd"           => "com.cloud.api.commands.DestroyVirtualMachineCmd",
            "created"       => Time.now.iso8601,
            "jobid"         => job_id,
            "jobstatus"     => 1,
            "jobprocstatus" => 0,
            "jobresultcode" => 0,
            "jobresulttype" => "object",
            "jobresult"     =>
              {"virtualmachine" => server}
          }

          self.data[:jobs][job_id]= job
          self.data[:servers].delete(identity)

          {"destroyvirtualmachineresponse" => {"jobid" => job_id}}
        end
      end
    end # Cloudstack
  end # Compute
end # Fog
