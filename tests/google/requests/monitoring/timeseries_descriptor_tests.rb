Shindo.tests('Fog::Google[:monitoring] | timeseries_descriptor requests', ['google']) do
  @monitoring = Fog::Google[:monitoring]

  @get_timeseries_descriptor_format = {
    'metric' => String,
    'project' => String,
    'labels' => Hash,
  }

  @list_timeseries_descriptors_format = {
    'kind' => String,
    'youngest' => String,
    'oldest' => String,
    'timeseries' => [@get_timeseries_descriptor_format],
  }

  tests('success') do

    tests('#list_timeseries_descriptors').formats(@list_timeseries_descriptors_format) do
      @monitoring.list_timeseries_descriptors('compute.googleapis.com/instance/uptime',
                                              Time.now.strftime("%Y-%m-%dT%H:%M:%S%:z")).body
    end

  end

end
