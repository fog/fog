module Fog
  module Compute
    class Cloudstack

      class Real
        # Destroys a virtual machine. Once destroyed, only the administrator can recover it.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/destroyVirtualMachine.html]
        def destroy_virtual_machine(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'destroyVirtualMachine') 
          else
            options.merge!('command' => 'destroyVirtualMachine', 
            'id' => args[0])
          end
          request(options)
        end
      end
 
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
    end
  end
end

