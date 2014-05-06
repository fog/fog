Shindo.tests('Fog::Compute[:cloudstack] | enable static nat requests', ['cloudstack']) do

  @nat_info_format = {
      'enablestaticnatresponse'  => {
          'count'          => Integer,
          'nat_info'       => {
             'displaytext' => String,
             'success'     => Fog::Boolean

          }
      }
  }

  tests('success') do
    tests('#enable_static_nat').formats(@nat_info_format) do
      Fog::Compute[:cloudstack].enable_static_nat
    end
  end

end
