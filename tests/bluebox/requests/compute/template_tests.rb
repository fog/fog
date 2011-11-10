Shindo.tests('Fog::Compute[:bluebox] | template requests', ['bluebox']) do

  @template_format = {
    'created'     => String,
    'description' => String,
    'id'          => String,
    'public'      => Fog::Boolean
  }

  tests('success') do

    @template_id  = '03807e08-a13d-44e4-b011-ebec7ef2c928' # Ubuntu LTS 10.04 64bit

    tests("get_template('#{@template_id}')").formats(@template_format) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].get_template(@template_id).body
    end

    tests("get_templates").formats([@template_format]) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].get_templates.body
    end

  end

  tests('failure') do

    tests("get_template('00000000-0000-0000-0000-000000000000')").raises(Fog::Compute::Bluebox::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].get_template('00000000-0000-0000-0000-000000000000')
    end

  end

end
