module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/basic'

        # Delete a security group that you own
        #
        # ==== Parameters
        # * group_name<~String> - Name of the security group, must be nil if id is specified
        # * group_id<~String> - Id of the security group, must be nil if name is specified
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-DeleteSecurityGroup.html]
        def delete_security_group(name, id = nil)
          if name && id
            raise Fog::Compute::AWS::Error.new("May not specify both group_name and group_id")
          end
          if name
            type_id    = 'GroupName'
            identifier = name
          else
            type_id    = 'GroupId'
            identifier = id
          end
          request(
            'Action'    => 'DeleteSecurityGroup',
            type_id     => identifier,
            :idempotent => true,
            :parser     => Fog::Parsers::Compute::AWS::Basic.new
          )
        end

      end

      class Mock
        def delete_security_group(name, id = nil)
          if name == 'default'
            raise Fog::Compute::AWS::Error.new("InvalidGroup.Reserved => The security group 'default' is reserved")
          end

          if name && id
            raise Fog::Compute::AWS::Error.new("May not specify both group_name and group_id")
          end
          if id
            name = self.data[:security_groups].reject { |k,v| v['groupId'] != id } .keys.first
          end

          response = Excon::Response.new
          if self.data[:security_groups][name]

            used_by_groups = []
            self.region_data.each do |access_key, key_data|
              key_data[:security_groups].each do |group_name, group|
                next if group == self.data[:security_groups][name]

                group['ipPermissions'].each do |group_ip_permission|
                  group_ip_permission['groups'].each do |group_group_permission|
                    if group_group_permission['groupName'] == name &&
                        group_group_permission['userId'] == self.data[:owner_id]
                      used_by_groups << "#{key_data[:owner_id]}:#{group_name}"
                    end
                  end
                end
              end
            end

            unless used_by_groups.empty?
              raise Fog::Compute::AWS::Error.new("InvalidGroup.InUse => Group #{self.data[:owner_id]}:#{name} is used by groups: #{used_by_groups.uniq.join(" ")}")
            end

            self.data[:security_groups].delete(name)
            response.status = 200
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id,
              'return'    => true
            }
            response
          else
            raise Fog::Compute::AWS::NotFound.new("The security group '#{name}' does not exist")
          end
        end
      end
    end
  end
end
