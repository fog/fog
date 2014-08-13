Shindo.tests('Fog::Google[:monitoring] | timeseries_descriptors model', ['google']) do
  @timeseries_descriptors = Fog::Google[:monitoring].timeseries_descriptors

  tests('success') do

    tests('#all').succeeds do
      @timeseries_descriptors.all('compute.googleapis.com/instance/uptime',
                                  Time.now.strftime("%Y-%m-%dT%H:%M:%S%:z"))
    end

  end

end
