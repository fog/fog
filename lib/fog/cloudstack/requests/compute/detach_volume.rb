module Fog
  module Compute
    class Cloudstack

      class Real
        # Detaches a disk volume from a virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/detachVolume.html]
        def detach_volume(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'detachVolume') 
          else
            options.merge!('command' => 'detachVolume')
          end
          request(options)
        end
      end
 
      class Mock
        def detach_volume(options={})
          volume_id = options['id']

          volume = self.data[:volumes][volume_id]
          unless volume
            raise Fog::Compute::Cloudstack::BadRequest.new("Unable to execute API command attachvolume due to invalid value. Object volumes(uuid: #{volume_id}) does not exist.")
          end

          volume['virtualmachineid']= volume['vmname']= volume['vmdisplayname']= nil

          job_id = Fog::Cloudstack.uuid

          # FIXME: need to determine current user
          account_id = self.data[:accounts].first
          user_id = self.data[:users].first

          job = {
            "accountid"     => account_id,
            "userid"        => user_id,
            "cmd"           => "com.cloud.api.commands.DetachVolumeCmd",
            "created"       => Time.now.iso8601,
            "jobid"         => job_id,
            "jobstatus"     => 1,
            "jobprocstatus" => 0,
            "jobresultcode" => 0,
            "jobresulttype" => "object",
            "jobresult"     =>
              {"volume"     => volume}
          }

          self.data[:jobs][job_id]= job

          {
            "detachvolumeresponse" => {
              "jobid" => job_id
            }
          }
        end
      end 
    end
  end
end

