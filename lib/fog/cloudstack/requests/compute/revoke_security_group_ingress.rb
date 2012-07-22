module Fog
  module Compute
    class Cloudstack
      class Real

        def revoke_security_group_ingress(options={})
          options.merge!(
            'command' => 'revokeSecurityGroupIngress'
          )

          request(options)
        end

      end # Real

      class Mock
        def revoke_security_group_ingress(options={})
          unless security_group_rule_id = options['id']
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command missing parameter id')
          end

          security_group_id, security_group = self.data[:security_groups].find do |id,group|
            group['ingressrule'] && group['ingressrule'].delete_if { |r| r['id'] == security_group_rule_id }
          end

          job_id = Fog::Cloudstack.uuid
          job = {
            "cmd"           => "com.cloud.api.commands.revokeSecurityGroupIngress",
            "created"       => Time.now.iso8601,
            "jobid"         => job_id,
            "jobstatus"     => 1,
            "jobprocstatus" => 0,
            "jobresultcode" => 0,
            "jobresulttype" => "object",
            "jobresult"     => { "securitygroup" => security_group }
          }

          self.data[:jobs][job_id]= job
          self.data[:security_groups][security_group_id] = security_group

          {"revokesecuritygroupingress" => { "jobid" => job_id }}
        end

      end
    end
  end
end

