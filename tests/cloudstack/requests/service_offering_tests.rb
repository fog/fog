Shindo.tests('Fog::Compute[:cloudstack] | service offering requests', ['cloudstack']) do

  @service_offerings_format = {
    'listserviceofferingsresponse'  => {
      'count' => Integer,
      'serviceoffering' => [
        'id' => String,
        'name' => String,
        'displaytext' => String,
        'cpuspeed' => Integer,
        'cpunumber' => Integer,
        'memory' => Integer,
        'created' => String,
        'storagetype' => String,
        'offerha' => Fog::Boolean,
        'limitcpuuse' => Fog::Boolean,
        'issystem' => Fog::Boolean,
        'defaultuse' => Fog::Boolean
      ]
    }
  }

  tests('success') do

    tests('#list_service_offerings').formats(@service_offerings_format) do
      Fog::Compute[:cloudstack].list_service_offerings
    end

  end

end
