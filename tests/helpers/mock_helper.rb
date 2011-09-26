# Use so you can run in mock mode from the command line
#
# FOG_MOCK=true fog

if ENV["FOG_MOCK"] == "true"
  Fog.mock!
end

# if in mocked mode, fill in some fake credentials for us
if Fog.mock?
  Fog.credentials = {
    :aws_access_key_id                => 'aws_access_key_id',
    :aws_secret_access_key            => 'aws_secret_access_key',
    :bluebox_api_key                  => 'bluebox_api_key',
    :bluebox_customer_id              => 'bluebox_customer_id',
    :brightbox_client_id              => 'brightbox_client_id',
    :brightbox_secret                 => 'brightbox_secret',
    :dnsimple_email                   => 'dnsimple_email',
    :dnsimple_password                => 'dnsimple_password',
    :dnsmadeeasy_api_key              => 'dnsmadeeasy_api_key',
    :dnsmadeeasy_secret_key           => 'dnsmadeeasy_secret_key',
    :ecloud_username                  => 'ecloud_username',
    :ecloud_password                  => 'ecloud_password',
    :ecloud_versions_uri              => 'http://ecloud.versions.uri',
    :glesys_username                  => 'glesys_username',
    :glesys_api_key                   => 'glesys_api_key',
    :go_grid_api_key                  => 'go_grid_api_key',
    :go_grid_shared_secret            => 'go_grid_shared_secret',
    :google_storage_access_key_id     => 'google_storage_access_key_id',
    :google_storage_secret_access_key => 'google_storage_secret_access_key',
    :linode_api_key                   => 'linode_api_key',
    :local_root                       => '~/.fog',
    :new_servers_password             => 'new_servers_password',
    :new_servers_username             => 'new_servers_username',
    :ninefold_compute_key             => 'ninefold_compute_key',
    :ninefold_compute_secret          => 'ninefold_compute_secret',
    :ninefold_storage_secret          => 'ninefold_storage_secret',
    :ninefold_storage_token           => 'ninefold_storage_token',
#    :public_key_path                  => '~/.ssh/id_rsa.pub',
#    :private_key_path                 => '~/.ssh/id_rsa',
    :openstack_api_key                => 'openstack_api_key',
    :openstack_username               => 'openstack_username',
    :openstack_tenant                 => 'openstack_tenant',
    :openstack_auth_url               => 'openstack_auth_url',
    :rackspace_api_key                => 'rackspace_api_key',
    :rackspace_username               => 'rackspace_username',
    :slicehost_password               => 'slicehost_password',
    :storm_on_demand_username         => 'storm_on_demand_username',
    :storm_on_demand_password         => 'storm_on_demand_password',
    :vcloud_host                      => 'vcloud_host',
    :vcloud_password                  => 'vcloud_password',
    :vcloud_username                  => 'vcloud_username',
    :voxel_api_key                    => 'voxel_api_key',
    :voxel_api_secret                 => 'voxel_api_secret',
    :zerigo_email                     => 'zerigo_email',
    :zerigo_token                     => 'zerigo_token',
    :dynect_customer                  => 'dynect_customer',
    :dynect_username                  => 'dynect_username',
    :dynect_password                  => 'dynect_password',
    :vsphere_server                   => 'virtualcenter.lan',
    :vsphere_username                 => 'apiuser',
    :vsphere_password                 => 'apipassword',
    :vsphere_expected_pubkey_hash     => 'abcdef1234567890'
  }
end
