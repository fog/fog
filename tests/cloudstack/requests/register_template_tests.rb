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
      register_response = Fog::Compute[:cloudstack].register_template("FogRegisterTest-#{Time.now.to_i}",
       'QCOW2',
       'KVM',
       "FogRegisterTest-#{Time.now.to_i}",
       Cloudstack::Compute::Constants::SYSTEM_VM_OS_TYPE_ID,
       'http://download.cloud.com/releases/2.2.0/systemvm.qcow2.bz2',
       -1,
       {'checksum' => 'ec463e677054f280f152fcc264255d2f'}
      )

      unless Fog.mocking?
        Fog::Compute[:cloudstack].delete_template('id' => register_response['registertemplateresponse']['template']['id'])
      end

      register_response
    end

  end

end