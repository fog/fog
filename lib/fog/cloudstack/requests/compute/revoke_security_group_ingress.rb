  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a particular ingress rule from this security group
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/revokeSecurityGroupIngress.html]
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

            security_group = self.data[:security_groups].values.find do |group|
              (rule = (group['ingressrule'] || []).find{|r| r['ruleid'] == security_group_rule_id}) && group['ingressrule'].delete(rule)
            end

            job_id = Fog::Cloudstack.uuid
            job = {
              "cmd" => "com.cloud.api.commands.revokeSecurityGroupIngress",
              "created" => Time.now.iso8601,
              "jobid" => job_id,
              "jobstatus" => 1,
              "jobprocstatus" => 0,
              "jobresultcode" => 0,
              "jobresulttype" => "object",
              "jobresult" => { "securitygroup" => security_group }
            }

            self.data[:jobs][job_id]= job

            {"revokesecuritygroupingress" => { "jobid" => job_id }}
          end

        end # Mock
      end # Cloudstack
    end # Compute
  end # Fog
