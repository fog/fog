Shindo.tests('Fog::Image[:openstack] | image requests', ['openstack']) do

  @image_format = {
    'id' => String,
    'name' => String,
    'size' => Fog::Nullable::Integer,
    'disk_format' => Fog::Nullable::String,
    'container_format' => Fog::Nullable::String,
    'checksum' => Fog::Nullable::String,
    'min_disk'  => Fog::Nullable::Integer,
    'created_at' => Fog::Nullable::String,
    'deleted_at' => Fog::Nullable::String,
    'updated_at' => Fog::Nullable::String,
    'deleted' => Fog::Nullable::Boolean,
    'protected' => Fog::Nullable::Boolean,
    'is_public' => Fog::Nullable::Boolean,
    'status' => Fog::Nullable::String,
    'min_ram' => Fog::Nullable::Integer,
    'owner' => Fog::Nullable::String,
    'properties' => Fog::Nullable::Hash
  }

  @image_meta_format ={
                     "X-Image-Meta-Is_public"=>String,
                     "X-Image-Meta-Min_disk"=>Fog::Nullable::String,
                     "X-Image-Meta-Property-Ramdisk_id"=>Fog::Nullable::String,
                     "X-Image-Meta-Disk_format"=>Fog::Nullable::String,
                     "X-Image-Meta-Created_at"=>String,
                     "X-Image-Meta-Container_format"=>Fog::Nullable::String,
                     "Etag"=>String,
                     "Location"=>String,
                     "X-Image-Meta-Protected"=>String,
                     "Date"=>String,
                     "X-Image-Meta-Name"=>String,
                     "X-Image-Meta-Min_ram"=>String,
                     "Content-Type"=>String,
                     "X-Image-Meta-Updated_at"=>String,
                     "X-Image-Meta-Property-Kernel_id"=>Fog::Nullable::String,
                     "X-Image-Meta-Size"=>String,
                     "X-Image-Meta-Checksum"=>Fog::Nullable::String,
                     "X-Image-Meta-Deleted"=>String,
                     "Content-Length"=>String,
                     "X-Image-Meta-Owner"=>String,
                     "X-Image-Meta-Status"=>String,
                     "X-Image-Meta-Id"=>String}

  @image_members_format =[
                          {"can_share"=>Fog::Nullable::Boolean,
                           "member_id"=>String
                          }
                         ]

  tests('success') do
    tests('#list_public_images').formats({'images' => [@image_format]}) do
      Fog::Image[:openstack].list_public_images.body
    end

    tests('#list_public_images_detailed').formats({'images' => [@image_format]}) do
      Fog::Image[:openstack].list_public_images.body
    end

    tests('#create_image').formats({'image' => @image_format}) do
      @instance = Fog::Image[:openstack].create_image({:name => "test image"}).body
    end

    tests('#get_image').formats(@image_meta_format) do
       Fog::Image[:openstack].get_image(@instance['image']['id']).headers
    end

    tests('#update_image').formats(@image_format) do
       Fog::Image[:openstack].update_image({:id => @instance['image']['id'],
                                            :name => "edit image"}).body['image']
    end

    tests('#add_member_to_image').succeeds do
       Fog::Image[:openstack].add_member_to_image(
           @instance['image']['id'], @instance['image']['owner'])
    end

    tests('#get_image_members').succeeds do
       Fog::Image[:openstack].get_image_members(@instance['image']['id'])
    end

    tests('#get_shared_images').succeeds do
       Fog::Image[:openstack].get_shared_images(@instance['image']['owner'])
    end

    tests('#remove_member_from_image').succeeds do
       Fog::Image[:openstack].remove_member_from_image(
           @instance['image']['id'], @instance['image']['owner'])
    end

    tests('#delete_image').succeeds do
      Fog::Image[:openstack].delete_image(@instance['image']['id'])
    end

  end
end
