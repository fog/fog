require 'fog/compute/models/server'

module Fog
  module Compute
    class IBM

      class Server < Fog::Compute::Server

        STATES = {
          0  => 'New',
          1  => 'Provisioning',
          2  => 'Failed',
          3  => 'Removed',
          4  => 'Rejected',
          5  => 'Active',
          6  => 'Unknown',
          7  => 'Deprovisioning',
          8  => 'Restarting',
          9  => 'Starting',
          10 => 'Stopping',
          11 => 'Stopped',
          12 => 'Deprovisioning pending',
          13 => 'Restart pending',
          14 => 'Attaching',
          15 => 'Detaching'
        }

        identity :id

        attribute :disk_size, :aliases => 'diskSize'
        attribute :expires_at, :aliases => 'expirationTime'
        attribute :image_id, :aliases => 'imageId'
        attribute :instance_type, :aliases => 'instanceType'
        attribute :ip
        attribute :key_name, :aliases => 'keyName'
        attribute :launched_at, :aliases => 'launchTime'
        attribute :location_id, :aliases => 'location'
        attribute :name
        attribute :owner
        attribute :primary_ip, :aliases => 'primaryIP'
        attribute :product_codes, :aliases => 'productCodes'
        attribute :request_id, :aliases => 'requestId'
        attribute :request_name, :aliases => 'requestName'
        attribute :is_mini_ephemeral, :aliases => 'isMiniEphemeral'
        attribute :secondary_ip, :aliases => 'secondaryIP'
        attribute :software
        attribute :state, :aliases => 'status'
        attribute :volume_ids, :aliases => 'volumes'
        attribute :vlan_id, :aliases => 'vlanID'

        def initialize(new_attributes={})
          super(new_attributes)
          self.name ||= 'fog-instance'
          self.image_id ||= '20010001'
          self.location_id ||= '41'
          self.instance_type ||= 'COP32.1/2048/60'
          self.key_name ||= 'fog'
        end

        def save
          requires :name, :image_id, :instance_type, :location_id
          data = connection.create_instance(name, image_id, instance_type, location_id,
                                            :key_name => key_name,
                                            :vlan_id => vlan_id,
                                            :secondary_ip => secondary_ip)
          data.body['instances'].each do |iattrs|
            if iattrs['name'] == name
              merge_attributes(iattrs)
              return true
            end
          end
          false
        end

        def state
          STATES[attributes[:state]]
        end

        def ready?
          state == "Active"
        end

        def reboot
          requires :id
          connection.modify_instance(id, 'state' => 'restart').body['success']
        end

        def destroy
          requires :id
          connection.delete_instance(id).body['success']
        end

        def rename(name)
          requires :id
          if connection.modify_instance(id, 'name' => name).body["success"]
            attributes[:name] = name
          else
            return false
          end
          true
        end

        def allocate_ip(wait_for_ready=true)
          requires :location_id
          new_ip = connection.addresses.new(:location => location_id)
          new_ip.save
          new_ip.wait_for(Fog::IBM.timeout) { ready? } if wait_for_ready
          secondary_ip << new_ip
          new_ip
        end

        def addresses
          addys = secondary_ip.map {|ip| Fog::Compute[:ibm].addresses.new(ip) }
          # Set an ID, in case someone tries to save
          addys << connection.addresses.new(attributes[:primary_ip].merge(
            :id => "0",
            :location => location_id,
            :state => 3
          ))
          addys
        end

        def attach(volume_id)
          requires :id
          data = connection.modify_instance(id, {'type' => 'attach', 'storageId' => volume_id})
          data.body
        end

        def detach(volume_id)
          requires :id
          data = connection.modify_instance(id, {'type' => 'detach', 'storageId' => volume_id})
          data.body
        end

        def launched_at
          Time.at(attributes[:launched_at].to_f / 1000)
        end

        def expires_at
          Time.at(attributes[:expires_at].to_f / 1000)
        end

        # Sets expiration time - Pass an instance of Time.
        def expire_at(time)
          expiry_time = (time.tv_sec * 1000).to_i
          data = connection.modify_instance(id, 'expirationTime' => expiry_time)
          if data.body['expirationTime'] == expiry_time
            attributes[:expires_at] = expiry_time
            true
          else
            false
          end
        end

        # Expires the instance immediately
        def expire!
          expire_at(Time.now + 5)
        end

        def image
          requires :image_id
          connection.images.get(image_id)
        end

        def location
          requires :location_id
          connection.locations.get(location_id)
        end

        def public_hostname
          primary_ip ? primary_ip['hostname'] : nil
        end

        def public_ip_address
          primary_ip ? primary_ip['ip'] : nil
        end

        # Creates an image from the current instance
        # if name isn't passed then we'll take the current name and timestamp it
        def to_image(opts={})
         options = {
           :name => name + " as of " + Time.now.strftime("%Y-%m-%d %H:%M"),
           :description => ""
         }.merge(opts)
         connection.create_image(id, options[:name], options[:description]).body
        end
        alias :create_image :to_image
      end

    end
  end

end
