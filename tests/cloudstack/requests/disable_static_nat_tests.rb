Shindo.tests('Fog::Compute[:cloudstack] | disable static nat requests', ['cloudstack']) do

  @nat_info_format = {
      'disablestaticnatresponse'  => {
          'count'          => Integer,
          'nat_info'       => {
             'displaytext' => String,
             'success'     => Fog::Boolean

          }
      }
  }

  tests('success') do
    tests('#disable_static_nat').formats(@nat_info_format) do
      Fog::Compute[:cloudstack].disable_static_nat
    end
  end

end
