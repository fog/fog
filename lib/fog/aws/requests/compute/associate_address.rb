module Fog
  module Compute
    class AWS
      class Real

        require 'fog/aws/parsers/compute/associate_address'

        # Associate an elastic IP address with an instance
        #
        # ==== Parameters
        # * instance_id<~String> - Id of instance to associate address with (conditional) 
        # * public_ip<~String> - Public ip to assign to instance (conditional)
        # * network_interface_id<~String> - Id of a nic to associate address with (required in a vpc instance with more than one nic) (conditional)
        # * allocation_id<~String> - Allocation Id to associate address with (vpc only) (conditional)
        # * privae_ip_address<~String> - Private Ip Address to associate address with (vpc only)
        # * allow_reassociation<~Boolean> - Allows an elastic ip address to be reassigned  (vpc only) (conditional)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'return'<~Boolean> - success?
        #     * 'associationId'<~String> - association Id for eip to node (vpc only)
        #
        # {Amazon API Reference}[http://docs.amazonwebservices.com/AWSEC2/latest/APIReference/ApiReference-query-AssociateAddress.html]
        def associate_address(*args)

          if args.first.kind_of? Hash
            params = {
              :instance_id => nil,
              :public_ip => nil,
              :network_interface_id => nil,
              :allocation_id => nil,
              :private_ip_address => nil,
              :allow_reassociation => nil,
            }.merge(args.first)
          else args.first.kind_of? Hash
            params = {
                :instance_id => args[0] || nil,
                :public_ip => args[1] || nil,
                :network_interface_id => args[2] || nil,
                :allocation_id => args[3] || nil,
                :private_ip_address => args[4] || nil,
                :allow_reassociation => args[5] || nil,
            }
          end
          # Cannot specify an allocation ip and a public IP at the same time.  If you have an allocation Id presumably you are in a VPC
          # so we will null out the public IP
          params[:public_ip] = params[:allocation_id].nil? ? params[:public_ip] : nil
          request(
            'Action'             => 'AssociateAddress',
            'AllocationId'       => params[:allocation_id],
            'InstanceId'         => params[:instance_id],
            'NetworkInterfaceId' => params[:network_interface_id],
            'PublicIp'           => params[:public_ip],
            'PrivateIpAddress'   => params[:private_ip_address],
            'AllowReassociation' => params[:allow_reassociation],
            :idempotent          => true,
            :parser              => Fog::Parsers::Compute::AWS::AssociateAddress.new
          )
        end

      end

      class Mock

        def associate_address(*args)
          if args.first.kind_of? Hash
            params = {
              :instance_id => nil,
              :public_ip => nil,
              :network_interface_id => nil,
              :allocation_id => nil,
              :private_ip_address => nil,
              :allow_reassociation => nil,
            }.merge(args.first)
          else args.first.kind_of? Hash
            params = {
                :instance_id => args[0] || nil,
                :public_ip => args[1] || nil,
                :network_interface_id => args[2] || nil,
                :allocation_id => args[3] || nil,
                :private_ip_address => args[4] || nil,
                :allow_reassociation => args[5] || nil,
            }
          end
          params[:public_ip] = params[:allocation_id].nil? ? params[:public_ip] : nil
          response = Excon::Response.new
          response.status = 200
          instance = self.data[:instances][params[:instance_id]]
          address = params[:public_ip].nil? ? nil : self.data[:addresses][params[:public_ip]]
          if ((instance && address) || (instance &&  !params[:allocation_id].nil?) || (!params[:allocation_id].nil? && !network_interface_id.nil?))
            if !params[:allocation_id].nil?
              allocation_ip = describe_addresses( 'allocation-id'  => "#{params[:allocation_id]}").body['addressesSet'].first
              if !allocation_ip.nil?
                public_ip = allocation_ip['publicIp']
                address = public_ip.nil? ? nil : self.data[:addresses][public_ip]
              end
            end
            if !address.nil?
              if current_instance = self.data[:instances][address['instanceId']]
                current_instance['ipAddress'] = current_instance['originalIpAddress']
              end
              address['instanceId'] = params[:instance_id]
            end
            # detach other address (if any)
            if self.data[:addresses][instance['ipAddress']]
              self.data[:addresses][instance['ipAddress']]['instanceId'] = nil
            end
            if !params[:public_ip].nil?
              instance['ipAddress'] = params[:public_ip]
              instance['dnsName'] = Fog::AWS::Mock.dns_name_for(params[:public_ip])
            end
            response.status = 200
            if !params[:instance_id].nil? && !params[:public_ip].nil?
              response.body = {
                'requestId' => Fog::AWS::Mock.request_id,
                'return'    => true
              }
            elsif !params[:allocation_id].nil?
              response.body = {
                'requestId'     => Fog::AWS::Mock.request_id,
                'return'        => true,
                'associationId' => Fog::AWS::Mock.request_id
              }
            end
            response
          #elsif ! network_interface_id.nil? && allocation_id.nil?
          #  raise Fog::Compute::AWS::NotFound.new("You must specify an AllocationId when specifying a NetworkInterfaceID")
          #elsif instance.nil? && network_interface_id.nil?
          #  raise Fog::Compute::AWS::Error.new("You must specify either an InstanceId or a NetworkInterfaceID")
          #elsif !instance && !network_interface_id
          #  raise Fog::Compute::AWS::Error.new(" 2 You must specify either an InstanceId or a NetworkInterfaceID")
          elsif !instance
            raise Fog::Compute::AWS::NotFound.new("You must specify either an InstanceId or a NetworkInterfaceID")
          elsif !address
            raise Fog::Compute::AWS::Error.new("AuthFailure => The address '#{public_ip}' does not belong to you.")
          end
        end

      end
    end
  end
end
