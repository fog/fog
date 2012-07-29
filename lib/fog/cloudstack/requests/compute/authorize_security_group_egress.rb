module Fog
  module Compute
    class Cloudstack
      class Real
        def authorize_security_group_egress(options={})
          options.merge!(
            'command' => 'authorizeSecurityGroupEgress'
          )

          request(options)
        end
      end # Real
      class Mock
        def authorize_security_group_egress(options={})
          security_group_id      = options['securitygroupid']
          security_group_rule_id = Fog::Cloudstack.uuid

          unless cidr = options['cidrlist']
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command missing parameter cidr')
          end

          unless start_port = options['startport']
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command missing parameter start_port')
          end

          unless end_port = options['endport']
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command missing parameter end_port')
          end

          unless protocol = options['protocol']
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command missing parameter protocol')
          end

          rule = {
            "ruleid"    => security_group_rule_id,
            "cidr"      => cidr,
            "startport" => start_port,
            "endport"   => end_port,
            "protocol"  => protocol
          }

          unless security_group = self.data[:security_groups][security_group_id]
            raise Fog::Compute::Cloudstack::BadRequest.new("Security group id #{security_group_id} does not exist")
          end

          security_group["egressrule"] ||= []
          security_group["egressrule"] << rule

          job_id = Fog::Cloudstack.uuid
          job = {
            "cmd"           => "com.cloud.api.commands.authorizeSecurityGroupEgress",
            "created"       => Time.now.iso8601,
            "jobid"         => job_id,
            "jobstatus"     => 1,
            "jobprocstatus" => 0,
            "jobresultcode" => 0,
            "jobresulttype" => "object",
            "jobresult"     => { "securitygroup" => security_group }
          }

          self.data[:jobs][job_id]= job

          { "authorizesecuritygroupegressresponse" => { "jobid" => job_id } }
        end
      end # Mock
    end
  end
end
