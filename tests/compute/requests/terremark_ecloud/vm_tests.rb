Shindo.tests('TerremarkEcloud::Compute | vm requests', ['terremark_ecloud']) do

  @instantiate_vm_template_format = {
    'name' => String,
    'uri' => String,
    'status' => String
  }

  @get_vm_deploying_format = {
    'name' => String,
    'uri'  => String,
    'status' => String,
    'storage_size' => Integer,
    'vdc_uri' => String,
    'extension_uri' => String,
    'network_connections' => [],
    'disks' => []
  }

  @get_vm_format = {
    'name' => String,
    'uri'  => String,
    'status' => String,
    'storage_size' => Integer,
    'vdc_uri' => String,
    'extension_uri' => String,
    'network_connections' => [{
        'name' => String,
        'ip_address' => String
      }],
    'cpus' => Integer,
    'memory' => Integer,
    'disks' => [{
        'id' => Integer,
        'size' => Integer
      }]
  }

  @power_on_vm_format = {
    'task_uri' => String
  }

  @power_reset_vm_format = {
    'task_uri' => String
  }

  @power_off_vm_format = {
    'task_uri' => String
  }

  @shutdown_vm_format = {
    'task_uri' => String
  }

  @delete_vm_format = {
    'task_uri' => String
  }

  tests('success') do

    tests("#instantiate_vm_template").formats(@instantiate_vm_template_format) do
      TerremarkEcloud::Compute.create_vm!.tap do |data|
        @vm_uri = data['uri']
      end
    end

    tests("#get_vm when deploying").formats(@get_vm_deploying_format) do
      TerremarkEcloud[:compute].get_vm(@vm_uri).body
    end

    # to be replaced with server.wait_for
    Fog.wait_for(600, 10) do
      TerremarkEcloud[:compute].get_vm(@vm_uri).body['status'] == 'powered_off'
    end

    tests("#get_vm").formats(@get_vm_format) do
      TerremarkEcloud[:compute].get_vm(@vm_uri).body
    end

    tests("#power_on_vm").formats(@power_on_vm_format) do
      TerremarkEcloud[:compute].power_on_vm(@vm_uri).tap do |data|
        @power_task_uri = data['task_uri']
      end
    end

    Fog.wait_for { TerremarkEcloud[:compute].get_task(@power_task_uri).body['status'] == 'success' }

    tests("#power_off_vm").formats(@power_off_vm_format) do
      TerremarkEcloud[:compute].power_off_vm(@vm_uri).tap do |data|
        @power_task_uri = data['task_uri']
      end
    end

    Fog.wait_for { TerremarkEcloud[:compute].get_task(@power_task_uri).body['status'] == 'success' }

    @power_task_uri = TerremarkEcloud[:compute].power_on_vm(@vm_uri)['task_uri']
    Fog.wait_for { TerremarkEcloud[:compute].get_task(@power_task_uri).body['status'] == 'success' }

    tests("#shutdown_vm").formats(@shutdown_vm_format) do
      pending # need to wait for the VM to boot up
      TerremarkEcloud[:compute].shutdown_vm(@vm_uri).tap do |data|
        @power_task_uri = data['task_uri']
      end
    end

    #Fog.wait_for { TerremarkEcloud[:compute].get_task(@power_task_uri).body['status'] == 'success' }

    tests("#delete_vm").formats(@delete_vm_format) do
      TerremarkEcloud[:compute].delete_vm(@vm_uri)
    end

  end

end
