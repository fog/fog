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
    end
  end
end
