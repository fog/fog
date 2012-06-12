def compute_providers
  {
    :aws        => {
      :server_attributes => {},
      :mocked => true
    },
    :bluebox    => {
      :server_attributes => {
        :flavor_id    => '94fd37a7-2606-47f7-84d5-9000deda52ae', # Block 1GB Virtual Server
        :image_id     => 'a8f05200-7638-47d1-8282-2474ef57c4c3', # Scientific Linux 6
        :location_id  => '37c2bd9a-3e81-46c9-b6e2-db44a25cc675', # Seattle, WA
        :password     => 'chunkybacon'
      },
      :mocked => false
    },
    :brightbox  => {
      :server_attributes => {
        :image_id => 'img-wwgbb' # Ubuntu Lucid 10.04 server (i686)
      },
      :mocked => false
    },
    :openstack => {
      :mocked => true,
      :server_attributes => {
        :flavor_ref => 2,
        :image_ref  => "0e09fbd6-43c5-448a-83e9-0d3d05f9747e",
        :name       => "fog_#{Time.now.to_i}"
      }
    },
    :cloudstack => {
      :provider_attributes => {
        :cloudstack_host => 'http://host.foo'
      },
      :server_attributes => {}.tap do |hash|
        [:zone_id, :network_ids, :image_id, :flavor_id].each do |k|
          hash[k]= Fog.credentials[:cloudstack] && Fog.credentials[:cloudstack][k]
        end
      end,
      :volume_attributes => {:name => "somevolume"}.tap do |hash|
        [:zone_id, :disk_offering_id].each do |k|
          hash[k]= Fog.credentials[:cloudstack] && Fog.credentials[:cloudstack][k]
        end
      end,
      :mocked => true
    },
    :glesys   => {
      :server_attributes => {
        :rootpassword  => "secret_password_#{Time.now.to_i}",
        :hostname      => "fog.example#{Time.now.to_i}.com"
      },
      :mocked => false
    },
    :hp       => {
      :server_attributes => {
        :flavor_id => 100,
        :image_id  => 1242,
        :name      => "fog_#{Time.now.to_i}"
      },
      :mocked => true
    },
    :ibm => {
      :server_attributes => {},
      :mocked => true
    },
    :joyent => {
      :mocked => false
    },
    :ninefold   => {
      :mocked => false
    },
    :rackspace  => {
      :server_attributes => {
        :image_id => 49, # image 49 = Ubuntu 10.04 LTS (lucid)
        :name     => "fog_#{Time.now.to_i}"
      },
      :mocked => true
    },
    :voxel      => {
      :server_attributes => {
        :name => "fog.#{Time.now.to_i}",
        :disk_size => 10,
        :processing_cores => 1,
        :image_id => 55, # image 55 = Ubuntu 10.04 (Lucid), 64-bit, base install
        :facility => "LDJ1"
      },
      :mocked => false
    }
  }
end
