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
        :image_id => Brightbox::Compute::TestSupport.image_id
      },
      :mocked => false
    },
    :ecloud => {
      :server_attributes => {
        :name                 => "eugene",
        :row                  => "eugene1",
        :group                => "eugene-104",
        :catalog_network_name => "bridged",
        :description          => "blarg",
        :operating_system => {
          :name =>  "Red Hat Enterprise Linux 5 (64-bit)",
          :href => "/cloudapi/ecloud/operatingsystems/rhel5_64guest/computepools/963",
        },
      }.tap do |hash|
        [:template_href, :network_uri, :environment_name].each do |k|
          key = "ecloud_#{k}".to_sym
          if Fog.credentials[key]
            hash[k]= Fog.credentials[key]
          end
        end
      end,
      :mocked => true,
    },
    :cloudstack => {
      :provider_attributes => {
        :cloudstack_host => 'http://host.foo'
      },
      :server_attributes => {}.tap do |hash|
        [:zone_id, :network_ids, :template_id, :service_offering_id].each do |k|
          key = "cloudstack_#{k}".to_sym
          if Fog.credentials[key]
            hash[k]= Fog.credentials[key]
          end
        end
      end,
      :volume_attributes => {:name => "somevolume"}.tap do |hash|
        [:zone_id, :disk_offering_id].each do |k|
          key = "cloudstack_#{k}".to_sym
          if Fog.credentials[key]
            hash[k]= Fog.credentials[key]
          end
        end
      end,
      :snapshot_attributes => {:volume_id => "89198f7c-0245-aa1d-136a-c5f479ef9db7"}.tap do |hash|
        [:volume_id, :domain_id, :policy_id].each do |k|
          key = "cloudstack_#{k}".to_sym
          if Fog.credentials[key]
            hash[k]= Fog.credentials[key]
          end
        end
      end,
      :security_group_attributes => {:name => "cloudstack.sg.#{Time.now.to_i}"},
      :security_group_rule_attributes => {
        :cidr => '0.0.0.0/0',
        :start_port => 123,
        :end_port => 456,
        :protocol => 'tcp'
      },
      :disk_offering_attributes => { :name => "new disk offering", :display_text => 'New Disk Offering' },
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
    :hp       => {
      :server_attributes => {
        :flavor_id => 100,
        :image_id => 1242,
        :name     => "fog_#{Time.now.to_i}"
      },
      :mocked => true
    },
    :ninefold   => {
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
    :rackspace  => {
      :provider_attributes => { :version => :v1 }, 
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
