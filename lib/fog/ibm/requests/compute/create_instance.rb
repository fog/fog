module Fog
  module Compute
    class IBM
      class Real

        # Create an instance
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def create_instance(name, image_id, instance_type, location, options={})
          request(
            :method   => 'POST',
            :expects  => 200,
            :path     => '/instances',
            :body     => {
              'name'                    => name,
              'imageID'                 => image_id,
              'instanceType'            => instance_type,
              'location'                => location,
              'publicKey'               => options[:key_name],
              'ip'                      => options[:ip],
              'volumeID'                => options[:volume_id],
              'vlanID'                  => options[:vlan_id],
              'SecondaryIP'             => options[:secondary_ip],
              'isMiniEphemermal'        => options[:is_mini_ephemeral],
              'Configuration Data'      => options[:configuration_data],
              'antiCollocationInstance' => options[:anti_collocation_instance],
            }
          )
        end

      end

      class Mock

        def create_instance(name="fog instance", image_id="20018425", instance_type="COP32.1/2048/60", location="101", public_key="fog", options={})
          response = Excon::Response.new
          # Since we want to test error conditions, we have a little regex that traps specially formed
          # instance type strings.
          case name
          when /FAIL:\ (\d{3})/
            response.status = $1
          else
            instance = Fog::IBM::Mock.create_instance(name, image_id, instance_type, location, public_key, options)
            self.data[:instances][instance['id']] = instance
            response.status = 200
            response.body = {"instances" => [ instance ]}
          end
          response
        end

      end
    end
  end
end
