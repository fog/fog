def compute_providers
  {
    AWS       => {
      :server_attributes => {
        :image_id => 'ami-1a837773' # image ami-1a837773 = Ubuntu
      },
      :mocked => true
    },
    Bluebox   => {
      :server_attributes => {
        :image_id => 'a00baa8f-b5d0-4815-8238-b471c4c4bf72', # Ubuntu 9.10 64bit
        :password => 'chunkybacon'
      },
      :mocked => false
    },
    Brightbox => {
      :server_attributes => {
        :image_id => 'img-9vxqi' # image img-9vxqi = Ubuntu Maverick 10.10 server
      },
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
