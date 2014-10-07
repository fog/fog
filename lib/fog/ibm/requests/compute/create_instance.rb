module Fog
  module Compute
    class IBM
      class Real
        # Requests a new Instance to be created.
        #
        # ==== Parameters
        # * name<~String> - The alias to use to reference this instance
        # * image_id<~String> - The id of the image to create this instance from
        # * instance_type<~String> - The instance type to use for this instance
        # * location<~String> - The id of the Location where this instance will be created
        # * options<~Hash>:
        #   * :key_name<~String> - The public key to use for accessing the created instance
        #   * :ip<~String> - The ID of a static IP address to associate with this instance
        #   * :volume_id<~String> - The ID of a storage volume to associate with this instance
        #   * :vlan_id<~String> - The ID of a Vlan offering to associate with this instance.
        #   * :secondary_ip<~String> - Comma separated list of static IP IDs to associate with this instance.
        #   * :is_mini_ephermal<~Boolean> - Whether or not the instance should be provisioned with the root segment only
        #   * :configuration_data<~Hash> - Arbitrary name/value pairs defined by the image being created
        #   * :anti_collocation_instance<~String> - The ID of an existing anti-collocated instance.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'name'<~String>: instance name
        #     * 'location'<~String>: instance location id
        #     * 'keyName'<~String>: instance assigned keypair
        #     * 'primaryIP'<~Hash>: assigned ip address, type, and hostname
        #     * 'productCodes'<~Array>: associated product codes
        #     * 'requestId'<~String>:
        #     * 'imageId'<~String>:
        #     * 'launchTime'<~Integer>: epoch time in ms representing when the instance was launched
        def create_instance(name, image_id, instance_type, location, options={})
          body_data     = {
            'name'                    => name,
            'imageID'                 => image_id,
            'instanceType'            => instance_type,
            'location'                => location,
            'publicKey'               => options[:key_name],
            'ip'                      => options[:ip],
            'volumeID'                => options[:volume_id],
            'vlanID'                  => options[:vlan_id],
            'isMiniEphemeral'        => options[:is_mini_ephemeral],
            'Configuration Data'      => options[:configuration_data],
            'antiCollocationInstance' => options[:anti_collocation_instance]
          }
          if options[:secondary_ip]
            options[:secondary_ip].split(',').map(&:strip).each_with_index do |n, idx|
              body_data.merge!({"secondary.ip.#{idx}" => n})
            end
          end
          request(
            :method   => 'POST',
            :expects  => 200,
            :path     => '/instances',
            :body     => body_data
          )
        end
      end

      class Mock
        def create_instance(name, image_id, instance_type, location, options={})
          response = Excon::Response.new
          # Since we want to test error conditions, we have a little regex that traps specially formed
          # instance type strings.
          case name
          when /FAIL:\ (\d{3})/
            response.status = $1.to_i
            raise Excon::Errors.status_error({:expects => 200}, response)
          else
            instance = Fog::IBM::Mock.create_instance(name, image_id, instance_type, location, options)
            self.data[:instances][instance['id']] = instance
            response.status = 200
            response.body = {"instances" => [ instance ]}
            response
          end
        end
      end
    end
  end
end
