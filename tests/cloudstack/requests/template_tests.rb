Shindo.tests('Fog::Compute[:cloudstack] | template requests', ['cloudstack']) do

  @templates_format = {
    'listtemplatesresponse'  => {
      'count' => Integer,
      'template' => [
        'id' => Integer,
        'name' => String,
        'displaytext' => String,
        'ispublic' => Fog::Boolean,
        'created' => String,
        'isready' => Fog::Boolean,
        'passwordenabled' => Fog::Boolean,
        'format' => String,
        'isfeatured' => Fog::Boolean,
        'crossZones' => Fog::Boolean,
        'ostypeid' => Integer,
        'ostypename' => String,
        'account' => String,
        'zoneid' => Integer,
        'zonename' => String,
        'status' => Fog::Nullable::String,
        'size' => Fog::Nullable::Integer,
        'templatetype' => String,
        'hypervisor' => String,
        'domain' => String,
        'domainid' => Integer,
        'isextractable' => Fog::Boolean,
        'checksum' => Fog::Nullable::String,
        'sourcetemplateid' => Fog::Nullable::Integer,
        'accountid' => Fog::Nullable::Integer,
        'bootable' => Fog::Nullable::Boolean,
        'hostid' => Fog::Nullable::Integer,
        'hostname' => Fog::Nullable::String,
        'jobid' => Fog::Nullable::Integer,
        'jobstatus' => Fog::Nullable::Integer,
        'removed' => Fog::Nullable::Boolean,
        'templatetag' => Fog::Nullable::String,
        'templatetype' => Fog::Nullable::String
      ]
    }
  }

  tests('success') do

    tests('#list_templates').formats(@templates_format) do
      pending if Fog.mocking?
      Fog::Compute[:cloudstack].list_templates('templateFilter' => "executable")
    end

  end

end
