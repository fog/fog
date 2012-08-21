module Fog
  module Compute
    class Cloudstack
      class Real

        # Attaches a disk volume to a virtual machine.
        #
        # {CloudStack API Reference}[http://http://download.cloud.com/releases/2.2.0/api_2.2.12/global_admin/attachVolume.html]
        def attach_volume(options={})
          options.merge!(
            'command' => 'attachVolume'
          )

          request(options)
        end

      end # Real

      class Mock

        def attach_volume(options={})
          volume_id = options['id']
          server_id = options['virtualmachineid']

          volume = self.data[:volumes][volume_id]
          unless volume
            raise Fog::Compute::Cloudstack::BadRequest.new("Unable to execute API command attachvolume due to invalid value. Object volumes(uuid: #{volume_id}) does not exist.")
          end

          server = self.data[:servers][server_id]
          unless server
            raise Fog::Compute::Cloudstack::BadRequest.new("Unable to execute API command attachvolume due to invalid value. Object vm_instance(uuid: #{server_id}) does not exist.")
          end

          volume['virtualmachineid']= server['id']
          volume['vmname']= server['name']
          volume['vmdisplayname']= server['displayname']

          job_id = Fog::Cloudstack.uuid

          # FIXME: need to determine current user
          account_id = self.data[:accounts].first
          user_id = self.data[:users].first

          job = {
            "accountid"     => account_id,
            "userid"        => user_id,
            "cmd"           => "com.cloud.api.commands.AttachVolumeCmd",
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
            "attachvolumeresponse" => {
              "jobid" => job_id
            }
          }
        end
      end # Mock
    end # Cloudstack
  end # Compute
end # Fog
