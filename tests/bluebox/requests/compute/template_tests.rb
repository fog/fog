Shindo.tests('Fog::Compute[:bluebox] | template requests', ['bluebox']) do

  @template_format = {
    'created'     => String,
    'description' => String,
    'id'          => String,
    'public'      => Fog::Boolean,
    'locations'   => [ String ],
    'status'      => String
  }

  tests('success') do

    @template_id = compute_providers[:bluebox][:server_attributes][:image_id]

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
