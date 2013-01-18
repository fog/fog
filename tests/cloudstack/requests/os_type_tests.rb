Shindo.tests('Fog::Compute[:cloudstack] | os type requests', ['cloudstack']) do

  @os_types_format = {
    'listostypesresponse'  => {
      'count' => Integer,
      'ostype' => [
        'id' => Integer,
        'description' => String,
        'oscategoryid' => Integer
      ]
    }
  }

  @os_categories_format = {
    'listoscategoriesresponse'  => {
      'count' => Integer,
      'oscategory' => [
        'id' => Integer,
        'name' => String
      ]
    }
  }

  tests('success') do

    tests('#list_os_types').formats(@os_types_format) do
      pending if Fog.mocking?
      Fog::Compute[:cloudstack].list_os_types
    end
    
    tests('#list_os_categories').formats(@os_categories_format) do
      pending if Fog.mocking?
      Fog::Compute[:cloudstack].list_os_categories
    end

  end

end