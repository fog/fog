Shindo.tests('RiakCS::Usage | usage requests', ['riakcs']) do

  @blank_usage_format = {
    'Access' => {
      'Nodes'   => [],
      'Errors'  => []
    },
    'Storage' => {
      'Samples' => [],
      'Errors'  => []
    }
  }

  tests('Statistics retrieval with no data returned') do

    start_time = Time.now.utc + 86400
    end_time   = start_time   + 86400

    tests('via JSON').returns(@blank_usage_format) do

      Fog::RiakCS[:usage].get_usage(Fog.credentials[:riakcs_access_key_id],
                                    :types      => [:access, :storage],
                                    :start_time => start_time,
                                    :end_time   => end_time).body

    end
  end

end
