Shindo.tests("HP::LB | protocols requests", ['hp', 'lb', 'protocols']) do
  @protocol_format = {
    'name'    => String,
    'port'    => Integer
  }

  tests('success') do

    tests('#list_protocols').formats({'protocols' => [@protocol_format]}) do
      HP[:lb].list_protocols.body
    end
  end

end
