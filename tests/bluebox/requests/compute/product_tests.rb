Shindo.tests('Fog::Compute[:bluebox] | product requests', ['bluebox']) do

  @product_format = {
    'id' => String,
    'description' => String,
    'cost' => String
  }

  tests('success') do

    @flavor_id = compute_providers[:bluebox][:server_attributes][:flavor_id]

    tests("get_product('#{@flavor_id}')").formats(@product_format) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].get_product(@flavor_id).body
    end

    tests("get_products").formats([@product_format]) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].get_products.body
    end

  end

  tests('failure') do

    tests("get_product('00000000-0000-0000-0000-000000000000')").raises(Fog::Compute::Bluebox::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].get_product('00000000-0000-0000-0000-000000000000')
    end

  end

end
