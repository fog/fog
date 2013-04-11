module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a template of a virtual machine. The virtual machine must be in a STOPPED state.
        # A template created from this command is automatically designated as a private template visible to the account that created it.
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createTemplate.html]
        def create_template(options={})
          options.merge!(
              'command' => 'createTemplate'
          )

          request(options)
        end

      end # Real

      class Mock

        BadRequest = Fog::Compute::Cloudstack::BadRequest

        def create_template(options={})

          required_params = %w(displaytext name ostypeid)
          required_params.each do |param|
            if options[param].nil?
              bad_request_with_missing! param
            end
          end

          os_type_id = options['ostypeid']
          if self.data[:os_types][os_type_id].nil?
            bad_request_with_not_exist! 'guest_os', os_type_id
          end

          volume_id = options['volumeid']
          snapshot_id = options['snapshotid']

          if snapshot_id.nil? && volume_id.nil?
            raise BadRequest.new "Unable to find snapshot by id=null" # cloudstack ~>4.0 api response
          end

          if volume_id && self.data[:volumes][volume_id].nil?
            bad_request_with_not_exist! 'volume', volume_id
          end

          if snapshot_id && self.data[:snapshots][snapshot_id].nil?
            bad_request_with_not_exist! 'snapshot', snapshot_id
          end

          template_id = Fog::Cloudstack.uuid
          template = {
                "id"              => template_id,
                "name"            => options['name'],
                "displaytext"     => options['displaytext'],
                "ostypeid"        => os_type_id,
                "created"         => Time.now.iso8601
          }
          self.data[:images][template_id] = template

          account_id = self.data[:accounts].first
          user_id = self.data[:users].first

          job_id = Fog::Cloudstack.uuid

          job = {
            "accountid"     => account_id,
            "userid"        => user_id,
            "cmd"           => "com.cloud.api.commands.CreateTemplateCmd",
            "created"       => Time.now.iso8601,
            "jobid"         => job_id,
            "jobstatus"     => 1,
            "jobprocstatus" => 0,
            "jobresultcode" => 0,
            "jobresulttype" => "object",
            "jobresult"     =>
              {"template"   => template}
          }
          self.data[:jobs][job_id] = job

          { "createtemplateresponse" => { "id"=> template_id, "jobid"=> job_id } }
        end

      private
        def bad_request_with_missing!(missing_param)
          raise BadRequest.new "Unable to execute API command createtemplate due to missing parameter #{missing_param}"
        end

        def bad_request_with_not_exist!(name, uuid)
          raise BadRequest.new "invalid value. Object #{name}(uuid: #{uuid}) does not exist."
        end

      end # Mock
    end # Cloudstack
  end # Compute
end #Fog