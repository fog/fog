Shindo.tests('Fog::Compute[:linode] | linodeplans requests', ['linode']) do

  @linodeplans_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => [{
      'AVAIL' => {
         '2'  => Integer,
         '3'  => Integer,
         '4'  => Integer,
         '6'  => Integer,
         '7'  => Integer,
         '8'  => Integer,
         '9'  => Integer,
         '10' => Integer
      },
      'DISK'    => Integer,
      'PLANID'  => Integer,
      'PRICE'   => Float,
      'RAM'     => Integer,
      'LABEL'   => String,
      'XFER'    => Integer,
      'CORES'   => Integer,
      'HOURLY'  => Float
    }]
  })

  tests('success') do

    @linodeplan_id = nil

    tests('#avail_linodeplans').formats(@linodeplans_format) do
      pending if Fog.mocking?
      data = Fog::Compute[:linode].avail_linodeplans.body
      @linodeplan_id = data['DATA'].first['PLANID']
      data
    end

    tests("#avail_linodeplans(#{@linodeplan_id})").formats(@linodeplans_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].avail_linodeplans(@linodeplan_id).body
    end

  end

end
