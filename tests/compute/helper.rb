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
        :name                 => "VM4",
        :row                  => "Layout Row 1",
        :group                => "Layout Group 1",
        :catalog_network_name => "bridged",
        :description          => "blarg",
        :operating_system => {
          :name =>  "Red Hat Enterprise Linux 5 (64-bit)",
          :href => "/cloudapi/ecloud/operatingsystems/rhel5_64guest/computepools/963",
        },
        :organization_uri => 'organizations/2'
      }.tap do |hash|
        [:template_href, :network_uri,
         :environment_name, :organization_uri].each do |k|
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
      :provider_attributes => { :version => :v2 },
      :server_attributes => {
        :image_id => "23b564c9-c3e6-49f9-bc68-86c7a9ab5018", # Ubuntu 12.04 LTS (Precise Pangolin)
        :flavor_id => 2,
        :name     => "fog_#{Time.now.to_i}"
      },
      :mocked => true
    }
  }
end
