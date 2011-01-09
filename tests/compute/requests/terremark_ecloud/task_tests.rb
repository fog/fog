Shindo.tests('TerremarkEcloud::Compute | task requests', ['terremark_ecloud']) do

  @get_task_queued_format = {
    'uri' => String,
    'status' => String,
    'startTime' => Time,
    'endTime' => NilClass,
    'owner' => {
      'uri' => String,
      'type' => String,
      'name' => String
    },
    'result' => {}
  }

  @get_task_format = {
    'uri' => String,
    'status' => String,
    'startTime' => Time,
    'endTime' => Time,
    'owner' => {
      'uri' => String,
      'type' => String,
      'name' => String
    },
    'result' => {
      'uri' => String,
      'type' => String,
      'name' => String
    }
  }

  tests('success') do

    # this is heavy but it works to start

    @vm_uri = TerremarkEcloud::Compute.create_vm!(:wait_for_powered_off => true)['uri']

    # fragile
    tests("#get_task when queued").formats(@get_task_queued_format) do
      @task_uri = TerremarkEcloud[:compute].power_on_vm(@vm_uri)['task_uri']

      TerremarkEcloud[:compute].get_task(@task_uri).body
    end

    Fog.wait_for do
      TerremarkEcloud[:compute].get_task(@task_uri).body['status'] == 'success'
    end

    tests("#get_task").formats(@get_task_format) do
      TerremarkEcloud[:compute].get_task(@task_uri).body
    end

    TerremarkEcloud[:compute].delete_vm(@vm_uri)

  end

end
