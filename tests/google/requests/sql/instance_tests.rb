Shindo.tests('Fog::Google[:sql] | instance requests', ['google']) do
  @sql = Fog::Google[:sql]
  @instance_id = Fog::Mock.random_letters(16)

  @insert_instance_format = {
    'kind' => String,
    'operation' => String,
  }

  @get_instance_format = {
    'instance' => String,
    'currentDiskSize' => Fog::Nullable::String,
    'databaseVersion' => String,
    'etag' => String,
    'ipAddresses' => Fog::Nullable::String,
    'kind' => String,
    'maxDiskSize' => String,
    'project' => String,
    'region' => String,
    'serverCaCert' => Hash,
    'settings' => Hash,
    'state' => String,
  }

  @list_instances_format = {
    'kind' => String,
    'items' => [@get_instance_format],
  }

  @clone_instance_format = {
    'kind' => String,
    'operation' => String,
  }

  @export_instance_format = {
    'kind' => String,
    'operation' => String,
  }

  @import_instance_format = {
    'kind' => String,
    'operation' => String,
  }

  @reset_instance_ssl_config_format = {
    'kind' => String,
    'operation' => String,
  }

  @restart_instance_format = {
    'kind' => String,
    'operation' => String,
  }

  @set_instance_root_password_format = {
    'kind' => String,
    'operation' => String,
  }

  @update_instance_format = {
    'kind' => String,
    'operation' => String,
  }

  @delete_instance_format = {
    'kind' => String,
    'operation' => String,
  }

  tests('success') do

    tests('#insert_instance').formats(@insert_instance_format) do
      result = @sql.insert_instance(@instance_id, 'D1').body
      @sql.instances.get(@instance_id).wait_for { ready? }
      result
    end

    tests('#list_instances').formats(@list_instances_format) do
      @sql.list_instances.body
    end

    tests('#get_instance').formats(@get_instance_format) do
      @sql.get_instance(@instance_id).body
    end

    tests('#update_instance').formats(@update_instance_format) do
      instance = @sql.instances.get(@instance_id)
      @sql.update_instance(instance.instance, instance.settings_version, instance.tier, instance.attributes).body
    end

    tests('#clone_instance').formats(@clone_instance_format) do
      pending unless Fog.mocking? # Binary log must be activated
      instance_cloned_id = Fog::Mock.random_letters(16)
      clone_instance_format = @sql.clone_instance(@instance_id, instance_cloned_id).body
      @sql.delete_instance(instance_cloned_id)
      clone_instance_format
    end

    tests('#export_instance').formats(@export_instance_format) do
      pending unless Fog.mocking? # We don't have access to a Google Cloud Storage bucket
      @sql.export_instance(@instance_id, "gs://#{Fog::Mock.random_letters_and_numbers(16)}/mysql-export").body
    end

    tests('#import_instance').formats(@import_instance_format) do
      pending unless Fog.mocking? # We don't have access to a Google Cloud Storage bucket
      @sql.import_instance(@instance_id, "gs://#{Fog::Mock.random_letters_and_numbers(16)}/mysql-export").body
    end

    tests('#reset_instance_ssl_config').formats(@reset_instance_ssl_config_format) do
      @sql.reset_instance_ssl_config(@instance_id).body
    end

    tests('#set_instance_root_password').formats(@set_instance_root_password_format) do
      @sql.set_instance_root_password(@instance_id, Fog::Mock.random_letters_and_numbers(8)).body
    end

    tests('#restart_instance').formats(@restart_instance_format) do
      result = @sql.restart_instance(@instance_id).body
      @sql.operations.get(@instance_id, result['operation']).wait_for { ready? }
      result
    end

    tests('#delete_instance').formats(@delete_instance_format) do
      @sql.delete_instance(@instance_id).body
    end

  end

end
