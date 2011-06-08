def compute_providers
  {
    AWS       => {
      :server_attributes => {},
      :mocked => true
    },
    Bluebox   => {
      :server_attributes => {
        :image_id => '03807e08-a13d-44e4-b011-ebec7ef2c928', # Ubuntu 10.04 64bit
        :password => 'chunkybacon'
      },
      :mocked => false
    },
    Brightbox => {
      :server_attributes => {
        :image_id => 'img-2ab98' # Ubuntu Lucid 10.04 server (i686)
      },
      :mocked => false
    },
    Ninefold => {
      :mocked => false
    },
    Rackspace => {
      :server_attributes => {
        :image_id => 49, # image 49 = Ubuntu 10.04 LTS (lucid)
        :name     => "fog_#{Time.now.to_i}"
      },
      :mocked => true
    },
    Slicehost => {
      :server_attributes => {
        :image_id => 49, # image 49 = Ubuntu 10.04 LTS (lucid)
        :name     => "fog_#{Time.now.to_i}"
      },
      :mocked => false
    },
    Voxel => {
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
