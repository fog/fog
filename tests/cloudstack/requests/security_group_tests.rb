Shindo.tests('Fog::Compute[:cloudstack] | security group requests', ['cloudstack']) do

  @security_groups_format = {
    'listsecuritygroupsresponse'  => {
      'count' => Integer,
      'securitygroup' => [
        'id' => Integer,
        'account' => String,
        'description' => Fog::Nullable::String,
        'domain' => String,
        'domainid' => Integer,
        'jobid' => Fog::Nullable::Integer,
        'jobstatus' => Fog::Nullable::String,
        'name' => String,
        'ingressrule' => Fog::Nullable::Array
      ]
    }
  }

  tests('success') do

    tests('#list_security_groups').formats(@security_groups_format) do
      pending if Fog.mocking?
      Fog::Compute[:cloudstack].list_security_groups
    end

  end

end