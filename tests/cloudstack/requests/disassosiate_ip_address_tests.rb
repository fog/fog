Shindo.tests('Fog::Compute[:cloudstack] | disassosiate ip address requests', ['cloudstack']) do

  @disassociate_format = {
      'disassociateipaddressresponse'  => {
          'count'                   => Integer,
          'disassociate_info'                 => {
              'displaytext'       => String,
              'success'         => Fog::Boolean
          }
      }
  }

  tests('success') do
    tests('#disassosiate_ip_address').formats(@disassociate_format) do
      Fog::Compute[:cloudstack].disassociate_ip_address
    end
  end

end
