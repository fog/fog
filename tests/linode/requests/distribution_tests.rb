Shindo.tests('Linode | distribution requests', ['linode']) do

  @distributions_format = Linode::Formats::BASIC.merge({
    'DATA' => [{ 
      'CREATE_DT'           => String,
      'DISTRIBUTIONID'      => Integer,
      'IS64BIT'             => Integer,
      'LABEL'               => String,
      'MINIMAGESIZE'        => Integer,
      'REQUIRESPVOPSKERNEL' => Integer
    }]
  })

  tests('success') do

    @distribution_id = nil

    tests('#avail_distributions').formats(@distributions_format) do
      data = Linode[:linode].avail_distributions.body
      @distribution_id = data['DATA'].first['DISTRIBUTIONID']
      data
    end

    tests("@avail_distributions(#{@distribution_id})").formats(@distributions_format) do
      Linode[:linode].avail_distributions(@distribution_id).body
    end

  end

end
