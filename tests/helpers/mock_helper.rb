# Use so you can run in mock mode from the command line
#
# FOG_MOCK=true fog

if ENV["FOG_MOCK"] == "true"
  Fog.mock!
end

# if in mocked mode, fill in some fake credentials for us
if Fog.mock?
  Fog.instance_variable_set(:@credentials, {
    :aws_access_key_id                => 'aws_access_key_id',
    :aws_secret_access_key            => 'aws_secret_access_key',
    :bluebox_api_key                  => 'bluebox_api_key',
    :bluebox_customer_id              => 'bluebox_customer_id',
    :brightbox_client_id              => 'brightbox_client_id',
    :brightbox_secret                 => 'brightbox_secret',
    :go_grid_api_key                  => 'go_grid_api_key',
    :go_grid_shared_secret            => 'go_grid_shared_secret',
    :google_storage_access_key_id     => 'google_storage_access_key_id',
    :google_storage_secret_access_key => 'google_storage_secret_access_key',
    :linode_api_key                   => 'linode_api_key',
#    :local_root                       => '~/.fog'
    :new_servers_password             => 'new_servers_password',
    :new_servers_username             => 'new_servers_username',
#    :public_key_path                  => '~/.ssh/id_rsa.pub',
#    :private_key_path                 => '~/.ssh/id_rsa',
    :rackspace_api_key                => 'rackspace_api_key',
    :rackspace_username               => 'rackspace_username',
    :slicehost_password               => 'slicehost_password',
    :voxel_api_key                    => 'voxel_api_key',
    :voxel_api_secret                 => 'voxel_api_secret',
    :zerigo_email                     => 'zerigo_email',
    :zerigo_token                     => 'zerigo_token'
  })
end
