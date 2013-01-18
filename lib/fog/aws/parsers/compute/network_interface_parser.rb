module Fog
  module Parsers
    module Compute
      module AWS

        class NetworkInterfaceParser < Fog::Parsers::Base

          def reset_nic
            @nic = { 'groupSet' => {}, 'attachment' => {}, 'association' => {}, 'tagSet' => {} }
            @in_tag_set     = false
            @in_group_set   = false
            @in_attachment  = false
            @in_association = false
          end

          def reset
            reset_nic
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'tagSet'
              @in_tag_set = true
              @tag        = {}
            when 'groupSet'
              @in_group_set = true
              @group        = {}
            when 'attachment'
              @in_attachment = true
              @attachment    = {}
            when 'association'
              @in_association = true
              @association    = {}
            end
          end

          def end_element(name)
            if @in_tag_set
              case name
              when 'item'
                @nic['tagSet'][@tag['key']] = @tag['value']
                @tag = {}
              when 'key', 'value'
                @tag[name] = value
              when 'tagSet'
                @in_tag_set = false
              end
            elsif @in_group_set
              case name
              when 'item'
                @nic['groupSet'][@group['groupId']] = @group['groupName']
                @group = {}
              when 'groupId', 'groupName'
                @group[name] = value
              when 'groupSet'
                @in_group_set = false
              end
            elsif @in_attachment
              case name
              when 'attachmentId', 'instanceId', 'instanceOwnerId', 'deviceIndex', 'status', 'attachTime', 'deleteOnTermination'
                @attachment[name] = value
              when 'attachment'
                @nic['attachment'] = @attachment
                @in_attachment     = false
              end
            elsif @in_association
              case name
              when 'associationId', 'publicIp', 'ipOwnerId'
                @association[name] = value
              when 'association'
                @nic['association'] = @association
                @in_association     = false
              end
            else
              case name
              when 'networkInterfaceId', 'subnetId', 'vpcId', 'availabilityZone', 'description', 'ownerId', 'requesterId',
                'requesterManaged', 'status', 'macAddress', 'privateIpAddress', 'privateDnsName'
                @nic[name] = value
              when 'sourceDestCheck'
                @nic['sourceDestCheck'] = (value == 'true')
              end
            end
          end
        end
      end
    end
  end
end
