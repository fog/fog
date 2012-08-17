require 'fog/core/model'

module Fog
  module Compute
    class AWS

      class SecurityGroup < Fog::Model

        identity  :name,            :aliases => 'groupName'
        attribute :description,     :aliases => 'groupDescription'
        attribute :group_id,        :aliases => 'groupId'
        attribute :ip_permissions,  :aliases => 'ipPermissions'
        attribute :ip_permissions_egress,  :aliases => 'ipPermissionsEgress'
        attribute :owner_id,        :aliases => 'ownerId'
        attribute :vpc_id,          :aliases => 'vpcId'

        # Authorize access by another security group
        #
        #  >> g = AWS.security_groups.all(:description => "something").first
        #  >> g.authorize_group_and_owner("some_group_name", "1234567890")
        #
        # == Parameters:
        # group::
        #   The name of the security group you're granting access to.
        #
        # owner::
        #   The owner id for security group you're granting access to.
        #
        # == Returns:
        #
        # An excon response object representing the result
        #
        #  <Excon::Response:0x101fc2ae0
        #    @status=200,
        #    @body={"requestId"=>"some-id-string",
        #           "return"=>true},
        #    headers{"Transfer-Encoding"=>"chunked",
        #            "Date"=>"Mon, 27 Dec 2010 22:12:57 GMT",
        #            "Content-Type"=>"text/xml;charset=UTF-8",
        #            "Server"=>"AmazonEC2"}
        #

        def authorize_group_and_owner(group, owner = nil)
          Fog::Logger.deprecation("authorize_group_and_owner is deprecated, use authorize_port_range with :group option instead")

          requires_one :name, :group_id

          connection.authorize_security_group_ingress(
            name,
            'GroupId'                    => group_id,
            'SourceSecurityGroupName'    => group,
            'SourceSecurityGroupOwnerId' => owner
          )
        end

        # Authorize a new port range for a security group
        #
        #  >> g = AWS.security_groups.all(:description => "something").first
        #  >> g.authorize_port_range(20..21)
        #
        # == Parameters:
        # range::
        #   A Range object representing the port range you want to open up. E.g., 20..21
        #
        # options::
        #   A hash that can contain any of the following keys:
        #    :cidr_ip (defaults to "0.0.0.0/0")
        #    :group - ("account:group_name" or "account:group_id"), cannot be used with :cidr_ip
        #    :ip_protocol (defaults to "tcp")
        #
        # == Returns:
        #
        # An excon response object representing the result
        #
        #  <Excon::Response:0x101fc2ae0
        #    @status=200,
        #    @body={"requestId"=>"some-id-string",
        #           "return"=>true},
        #    headers{"Transfer-Encoding"=>"chunked",
        #            "Date"=>"Mon, 27 Dec 2010 22:12:57 GMT",
        #            "Content-Type"=>"text/xml;charset=UTF-8",
        #            "Server"=>"AmazonEC2"}
        #

        def authorize_port_range(range, options = {})
          requires_one :name, :group_id

          ip_permission = {
            'FromPort'   => range.min,
            'ToPort'     => range.max,
            'IpProtocol' => options[:ip_protocol] || 'tcp'
          }

          if options[:group].nil?
            ip_permission['IpRanges'] = [
              { 'CidrIp' => options[:cidr_ip] || '0.0.0.0/0' }
            ]
          else
            ip_permission['Groups'] = [
              group_info(options[:group])
            ]
          end

          connection.authorize_security_group_ingress(
            name,
            'GroupId'       => group_id,
            'IpPermissions' => [ ip_permission ]
          )
        end

        # Removes an existing security group
        #
        # security_group.destroy
        #
        # ==== Returns
        #
        # True or false depending on the result
        #

        def destroy
          requires_one :name, :group_id

          if group_id.nil?
            connection.delete_security_group(name)
          else
            connection.delete_security_group(nil, group_id)
          end
          true
        end

        # Revoke access by another security group
        #
        #  >> g = AWS.security_groups.all(:description => "something").first
        #  >> g.revoke_group_and_owner("some_group_name", "1234567890")
        #
        # == Parameters:
        # group::
        #   The name of the security group you're revoking access to.
        #
        # owner::
        #   The owner id for security group you're revoking access access to.
        #
        # == Returns:
        #
        # An excon response object representing the result
        #
        #  <Excon::Response:0x101fc2ae0
        #    @status=200,
        #    @body={"requestId"=>"some-id-string",
        #           "return"=>true},
        #    headers{"Transfer-Encoding"=>"chunked",
        #            "Date"=>"Mon, 27 Dec 2010 22:12:57 GMT",
        #            "Content-Type"=>"text/xml;charset=UTF-8",
        #            "Server"=>"AmazonEC2"}
        #

        def revoke_group_and_owner(group, owner = nil)
          Fog::Logger.deprecation("revoke_group_and_owner is deprecated, use revoke_port_range with :group option instead")

          requires_one :name, :group_id

          connection.revoke_security_group_ingress(
            name,
            'GroupId'                    => group_id,
            'SourceSecurityGroupName'    => group,
            'SourceSecurityGroupOwnerId' => owner
          )
        end

        # Revoke an existing port range for a security group
        #
        #  >> g = AWS.security_groups.all(:description => "something").first
        #  >> g.revoke_port_range(20..21)
        #
        # == Parameters:
        # range::
        #   A Range object representing the port range you want to open up. E.g., 20..21
        #
        # options::
        #   A hash that can contain any of the following keys:
        #    :cidr_ip (defaults to "0.0.0.0/0")
        #    :group - ("account:group_name" or "account:group_id"), cannot be used with :cidr_ip
        #    :ip_protocol (defaults to "tcp")
        #
        # == Returns:
        #
        # An excon response object representing the result
        #
        #  <Excon::Response:0x101fc2ae0
        #    @status=200,
        #    @body={"requestId"=>"some-id-string",
        #           "return"=>true},
        #    headers{"Transfer-Encoding"=>"chunked",
        #            "Date"=>"Mon, 27 Dec 2010 22:12:57 GMT",
        #            "Content-Type"=>"text/xml;charset=UTF-8",
        #            "Server"=>"AmazonEC2"}
        #

        def revoke_port_range(range, options = {})
          requires_one :name, :group_id

          ip_permission = {
            'FromPort'   => range.min,
            'ToPort'     => range.max,
            'IpProtocol' => options[:ip_protocol] || 'tcp'
          }

          if options[:group].nil?
            ip_permission['IpRanges'] = [
              { 'CidrIp' => options[:cidr_ip] || '0.0.0.0/0' }
            ]
          else
            ip_permission['Groups'] = [
              group_info(options[:group])
            ]
          end

          connection.revoke_security_group_ingress(
            name,
            'GroupId'       => group_id,
            'IpPermissions' => [ ip_permission ]
          )
        end

        # Create a security group
        #
        #  >> g = AWS.security_groups.new(:name => "some_name", :description => "something")
        #  >> g.save
        #
        # == Returns:
        #
        # True or an exception depending on the result. Keep in mind that this *creates* a new security group.
        # As such, it yields an InvalidGroup.Duplicate exception if you attempt to save an existing group.
        #

        def save
          requires :description, :name
          data = connection.create_security_group(name, description, vpc_id).body
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)
          true
        end

        private

        #
        # +group_arg+ may be a string or a hash with one key & value.
        #
        # If group_arg is a string, it is assumed to be the group name,
        # and the UserId is assumed to be self.owner_id.
        #
        # The "account:group" form is deprecated.
        #
        # If group_arg is a hash, the key is the UserId and value is the group.
        def group_info(group_arg)
          if Hash === group_arg
            account = group_arg.keys.first
            group   = group_arg.values.first
          elsif group_arg.match(/:/)
            account, group = group_arg.split(':')
            Fog::Logger.deprecation("'account:group' argument is deprecated. Use {account => group} or just group instead")
          else
            requires :owner_id
            account = owner_id
            group = group_arg
          end

          info = { 'UserId' => account }

          if group.start_with?("sg-")
            # we're dealing with a security group id
            info['GroupId'] = group
          else
            # this has to be a security group name
            info['GroupName'] = group
          end

          info
        end

      end

    end
  end
end
