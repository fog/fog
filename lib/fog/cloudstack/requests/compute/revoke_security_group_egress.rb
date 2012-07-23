module Fog
  module Compute
    class Cloudstack
      class Real
        def revoke_security_group_egress(options={})
          options.merge!(
            'command' => 'revokeSecurityGroupEgress'
          )

          request(options)
        end
      end # Real
      class Mock
        def revoke_security_group_egress(options={})
          unless security_group_rule_id = options['id']
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command missing parameter id')
          end

          security_group = self.data[:security_groups].values.find do |group|
            (rule = (group['egressrule'] || []).find{|r| r['ruleid'] == security_group_rule_id}) && group['egressrule'].delete(rule)
          end

          job_id = Fog::Cloudstack.uuid
          job = {
            "cmd"           => "com.cloud.api.commands.revokeSecurityGroupEgress",
            "created"       => Time.now.iso8601,
            "jobid"         => job_id,
            "jobstatus"     => 1,
            "jobprocstatus" => 0,
            "jobresultcode" => 0,
            "jobresulttype" => "object",
            "jobresult"     => { "securitygroup" => security_group }
          }

          self.data[:jobs][job_id]= job

          {"revokesecuritygroupegress" => { "jobid" => job_id }}
        end
      end # Mock
    end
  end
end
