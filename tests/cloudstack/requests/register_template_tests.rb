Shindo.tests('Fog::Compute[:cloudstack] | register template reqeusts', ['cloudstack']) do

  @register_template_format = {
    "registertemplateresponse" => {
      "template" =>
        [
          {"templatetype"     => String,
           "ostypename"       => String,
           "name"             => String,
           "hypervisor"       => String,
           "zonename"         => String,
           "format"           => String,
           "ispublic"         => Fog::Boolean,
           "domain"           => String,
           "account"          => String,
           "isfeatured"       => Fog::Boolean,
           "displaytext"      => String,
           "checksum"         => String,
           "ostypeid"         => Integer,
           "isready"          => Fog::Boolean,
           "id"               => Integer,
           "zoneid"           => Integer,
           "passwordenabled"  => Fog::Boolean,
           "domainid"         => Integer,
           "status"           => String,
           "crossZones"       => Fog::Boolean,
           "isextractable"    => Fog::Boolean,
           "created"          => String}
        ],
       "count" => Integer
    }
  }

  tests('success') do

    tests('#register_template').formats(@register_template_format) do
      Fog::Compute[:cloudstack].register_template('FogRegisterTest',
       'VHD',
       'XenServer',
       'FogRegisterTest',
       112,
       'http://domain.com/someimage.vhd.bz2',
       -1,
       {'checksum' => 'f90a36a7455a921f69ccda2d9df5c818'}
      )
    end

  end

end