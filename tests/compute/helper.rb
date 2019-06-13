def compute_providers
  {
    :aws        => {
      :server_attributes => {},
      :mocked => true
    },
    :glesys   => {
      :server_attributes => {
        :rootpassword  => "secret_password_#{Time.now.to_i}",
       :hostname      => "fog.example#{Time.now.to_i}.com"
      },
      :mocked => false
    },
    :ibm => {
      :server_attributes => {},
      :mocked => true
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
