Shindo.tests('Fog::Compute[:cloudstack] | service offering requests', ['cloudstack']) do

  @service_offerings_format = {
    'listserviceofferingsresponse'  => {
      'count' => Integer,
      'serviceoffering' => [
        'id' => Integer,
        'cpuspeed' => Integer,
        'cpunumber' => Integer,
        'created' => String,
        'defaultuse' => Fog::Boolean,
        'displaytext' => String,
        'domain' => Fog::Nullable::String,
        'domainid' => Fog::Nullable::Integer,
        'hosttags' => Fog::Nullable::String,
        'issystem' => Fog::Boolean,
        'limitcpuuse' => Fog::Boolean,
        'memory' => Integer,
        'name' => String,
        'networkrate' => Integer,
        'offerha' => Fog::Boolean,
        'storagetype' => String,
        'systemvmtype' => Fog::Nullable::String,
        'tags' => Fog::Nullable::String
      ]
    }
  }

  tests('success') do

    tests('#list_service_offerings').formats(@service_offerings_format) do
      pending if Fog.mocking?
      Fog::Compute[:cloudstack].list_service_offerings
    end

  end

end