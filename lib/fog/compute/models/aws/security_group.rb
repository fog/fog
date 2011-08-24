require 'fog/core/model'

module Fog
  module Compute
    class AWS

      class SecurityGroup < Fog::Model

        identity  :name,            :aliases => 'groupName'

        attribute :description,     :aliases => 'groupDescription'
        attribute :ip_permissions,  :aliases => 'ipPermissions'
        attribute :owner_id,        :aliases => 'ownerId'

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
          requires :name

          connection.authorize_security_group_ingress(
            name,
            'SourceSecurityGroupName'     => group,
            'SourceSecurityGroupOwnerId'  => owner
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
          requires :name

          connection.authorize_security_group_ingress(
            name,
            'CidrIp'      => options[:cidr_ip] || '0.0.0.0/0',
            'FromPort'    => range.min,
            'ToPort'      => range.max,
            'IpProtocol'  => options[:ip_protocol] || 'tcp'
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
          requires :name

          connection.delete_security_group(name)
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
          requires :name

          connection.revoke_security_group_ingress(
            name,
            'SourceSecurityGroupName'     => group,
            'SourceSecurityGroupOwnerId'  => owner
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
          requires :name

          connection.revoke_security_group_ingress(
            name,
            'CidrIp'      => options[:cidr_ip] || '0.0.0.0/0',
            'FromPort'    => range.min,
            'ToPort'      => range.max,
            'IpProtocol'  => options[:ip_protocol] || 'tcp'
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

          data = connection.create_security_group(name, description).body
          true
        end

      end

    end
  end
end
