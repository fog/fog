Shindo.tests('Fog::Compute[:cloudstack] | volume requests', ['cloudstack']) do

  @volumes_format = {
    'listvolumesresponse'  => {
      'count' => Integer,
      'volume' => [
        'id' => String,
        'name' => String,
        'zoneid' => String,
        'zonename' => String,
        'type' => String,
        'size' => Integer,
        'created' => String,
        'account' => String,
        'domainid' => String,
        'domain' => String,
        'state' => String,
        'storagetype' => String,
        'hypervisor' => String,
        'diskofferingid' => Fog::Nullable::String,
        'diskofferingname' => Fog::Nullable::String,
        'diskofferingdisplaytext' => Fog::Nullable::String,
        'storage' => String,
        'destroyed' => Fog::Boolean,
        'isextractable' => Fog::Boolean,
        'deviceid' => Fog::Nullable::Integer,
        'virtualmachineid' => Fog::Nullable::String,
        'vmname' => Fog::Nullable::String,
        'vmdisplayname' => Fog::Nullable::String,
        'vmstate' => Fog::Nullable::String,
        'serviceofferingid' => Fog::Nullable::Integer,
        'serviceofferingname' => Fog::Nullable::String,
        'serviceofferingdisplaytext' => Fog::Nullable::String,
        'attached' => Fog::Nullable::String
      ]
    }
  }

  tests('success') do

    tests('#list_volumes').formats(@volumes_format) do
      Fog::Compute[:cloudstack].list_volumes('zoneid' => 1)
    end

  end

end
