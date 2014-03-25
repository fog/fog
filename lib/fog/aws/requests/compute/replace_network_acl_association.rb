module Fog
  module Compute
    class AWS
      class Real
        require 'fog/aws/parsers/compute/replace_network_acl_association'

        # Replace the network ACL for a subnet with a
        #
        # ==== Parameters
        # * association_id<~String> - The ID of the current association between the original network ACL and the subnet
        # * network_acl_id<~String> - The ID of the network ACL
        #
        # === Returns
        # * response<~Excon::Response>:
        # * body<~Hash>:
        # * 'requestId'<~String> - Id of request
        # * 'return'<~Boolean> - Returns true if the request succeeds.
        #
        # {Amazon API Reference}[http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-ReplaceNetworkAclAssociation.html]
        def replace_network_acl_association(association_id, network_acl_id)
          request({
            'Action'        => 'ReplaceNetworkAclAssociation',
            'AssociationId' => association_id,
            'NetworkAclId'  => network_acl_id,
            :parser         => Fog::Parsers::Compute::AWS::ReplaceNetworkAclAssociation.new
          })
        end
      end

      class Mock
        def replace_network_acl_association(association_id, network_acl_id)
          response = Excon::Response.new
          if self.data[:network_acls][network_acl_id]
            # find the old assoc
            old_nacl = self.data[:network_acls].values.detect do |n|
              n['associationSet'].detect { |assoc| assoc['networkAclAssociationId'] == association_id }
            end

            unless old_nacl
              raise Fog::Compute::AWS::Error.new("Invalid association_id #{association_id}")
            end

            subnet_id = old_nacl['associationSet'].detect { |assoc| assoc['networkAclAssociationId'] == association_id }['subnetId']
            old_nacl['associationSet'].delete_if { |assoc| assoc['networkAclAssociationId'] == association_id }

            id = Fog::AWS::Mock.network_acl_association_id
            self.data[:network_acls][network_acl_id]['associationSet'] << {
              'networkAclAssociationId' => id,
              'networkAclId'            => network_acl_id,
              'subnetId'                => subnet_id,
            }

            response.status = 200
            response.body = {
              'requestId'        => Fog::AWS::Mock.request_id,
              'newAssociationId' => id
            }
            response
          else
            raise Fog::Compute::AWS::NotFound.new("The network ACL '#{network_acl_id}' does not exist")
          end
        end
      end
    end
  end
end
