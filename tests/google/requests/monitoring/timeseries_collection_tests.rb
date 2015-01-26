Shindo.tests('Fog::Google[:monitoring] | timeseries_collection requests', ['google']) do
  @monitoring = Fog::Google[:monitoring]

  @get_timeseries_format = {
    'timeseriesDesc' => Hash,
    'points' => Array,
  }

  @list_timeseries_format = {
    'kind' => String,
    'youngest' => String,
    'oldest' => String,
    'timeseries' => [@get_timeseries_format],
  }

  tests('success') do

    tests('#list_timeseries').formats(@list_timeseries_format) do
      @monitoring.list_timeseries('compute.googleapis.com/instance/uptime',
                                  Time.now.strftime("%Y-%m-%dT%H:%M:%S%:z")).body
    end

  end

end
