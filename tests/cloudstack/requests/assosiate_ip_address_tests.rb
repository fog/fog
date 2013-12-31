Shindo.tests('Fog::Compute[:cloudstack] | assosiate ip address requests', ['cloudstack']) do

  @ip_info_format = {
      'associateipaddressresponse'  => {
          'count'                   => Integer,
          'ip_info'                 => {
              'id'                        => String,
              'account'                   => String, 
              'description'               => Fog::Nullable::String,
              'domain'                    => Hash,
              'domainid'                  => String,
              'associatednetworkid'       => String,
              'forvirtualnetwork'         => Fog::Boolean,
              'ipaddress'                 => String,
              'issourcenat'               => Fog::Boolean,
              'isstaticnat'               => Fog::Boolean,
              'jobid'                     => String,
              'jobstatus'                 => String,
              'networkid'                 => String,
              'state'                     => String,
              'virtualmachinedisplayname' => String,
              'virtualmachineid'          => String,
              'virtualmachinename'        => String,
              'vlanid'                    => Integer,
              'vlanname'                  => String,
              'zoneid'                    => Integer,
              'zonename'                  => String
          }
      }
  }

  tests('success') do
    tests('#assosiate_ip_address').formats(@ip_info_format) do
      Fog::Compute[:cloudstack].associate_ip_address
    end
  end

end
