Shindo.tests('Fog::Compute[:cloudstack] | domain requests', ['cloudstack']) do

  @domains_format = {
    'listdomainsresponse'  => {
      'count' => Integer,
      'domain' => [
        'id' => Integer,
        'name' => String,
        'level' => Integer,
        'haschild' => Fog::Boolean,
        'parentdomainid' => Fog::Nullable::Integer,
        'parentdomainname' => Fog::Nullable::String
      ]
    }
  }

  tests('success') do

    tests('#list_domains').formats(@domains_format) do
      pending if Fog.mocking?
      Fog::Compute[:cloudstack].list_domains
    end

  end

end