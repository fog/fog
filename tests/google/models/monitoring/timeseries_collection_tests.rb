Shindo.tests('Fog::Google[:monitoring] | timeseries_collection model', ['google']) do
  @timeseries_collection = Fog::Google[:monitoring].timeseries_collection

  tests('success') do

    tests('#all').succeeds do
      @timeseries_collection.all('compute.googleapis.com/instance/uptime', Time.now.strftime("%Y-%m-%dT%H:%M:%S%:z"))
    end

  end

end
