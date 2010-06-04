Shindo.tests('Bluebox | product requests', ['bluebox']) do

  tests('success') do

    @product_id   = '94fd37a7-2606-47f7-84d5-9000deda52ae' # 1 GB

    tests("get_product('#{@product_id}')").formats(Bluebox::Formats::PRODUCT) do
      Bluebox[:blocks].get_product(@product_id).body
    end

    tests("get_products").formats([Bluebox::Formats::PRODUCT]) do
      Bluebox[:blocks].get_products.body
    end

  end

  tests('failure') do

    tests("get_product('00000000-0000-0000-0000-000000000000')").raises(Fog::Bluebox::NotFound) do
      Bluebox[:blocks].get_product('00000000-0000-0000-0000-000000000000')
    end

  end

end
