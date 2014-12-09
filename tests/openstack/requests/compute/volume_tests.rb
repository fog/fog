require 'fog/openstack'

Shindo.tests('Fog::Compute[:openstack] | volume requests', ['openstack']) do

  @volume_format = {
    'id'                  => String,
    'displayName'         => String,
    'size'                => Integer,
    'displayDescription'  => String,
    'status'              => String,
    'snapshotId'          => Fog::Nullable::String,
    'availabilityZone'    => String,
    'attachments'         => Array,
    'volumeType'          => Fog::Nullable::String,
    'createdAt'           => String,
    'metadata'            => Hash
  }

  tests('success') do
    tests('#create_volume').data_matches_schema({'volume' => @volume_format}) do
      Fog::Compute[:openstack].create_volume('loud', 'this is a loud volume', 3).body
    end

    tests('#list_volumes').data_matches_schema({'volumes' => [@volume_format]}) do
      Fog::Compute[:openstack].list_volumes.body
    end

    tests('#attach').succeeds do
      server_id = compute.create_server("test", get_image_ref, get_flavor_ref).body['server']['id']
      volume    = compute.volumes.all.first
      volume.attach(server_id, "vda")
    end

    tests('#attachments has one attachment').succeeds do
      compute.volumes.all.first.attachments.length == 1
    end

    tests('#get_volume_detail').data_matches_schema({'volume' => @volume_format}) do
      volume_id = Fog::Compute[:openstack].volumes.all.first.id
      Fog::Compute[:openstack].get_volume_details(volume_id).body
    end

    tests('#delete_volume').succeeds do
      volume_id = Fog::Compute[:openstack].volumes.all.first.id
      Fog::Compute[:openstack].delete_volume(volume_id)
    end
  end
end
