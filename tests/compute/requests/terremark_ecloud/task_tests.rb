Shindo.tests('TerremarkEcloud::Compute | task requests', ['terremarkecloud']) do

  @task_format = {
    'endTime'   => Fog::Nullable::Time,
    'href'      => String,
    'Owner'  => {
      'href'  => String,
      'name'  => String,
      'type'  => String
    },
    'Result'  => {
      'href'  => String,
      'name'  => String,
      'type'  => String
    },
    'type'      => String,
    'startTime' => Time,
    'status'    => String
  }

  tests('success') do

    @task_list_href = TerremarkEcloud[:compute].get_organization.body['Link'].detect {|link| link['type'] == 'application/vnd.vmware.vcloud.tasksList+xml'}['href']

    tests("#get_task_list").formats({'Tasks' => [@task_format]}) do
      pending if Fog.mocking?
      data = TerremarkEcloud[:compute].get_task_list(@task_list_href).body
      @task_href = data['Tasks'].first['href']
      data
    end

    tests("#get_task").formats(@task_format) do
      pending if Fog.mocking?
      TerremarkEcloud[:compute].get_task(@task_href).body
    end

  end

end
