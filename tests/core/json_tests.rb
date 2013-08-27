Shindo.tests('Fog::JSON', ['core']) do
  tests('decode') do
    tests('object').raises(Exception) do
      Fog::JSON.decode(['a', 'b'])
    end

    tests('nil').returns(nil) do
      Fog::JSON.decode(nil)
    end
    tests('empty').returns(nil) do
      Fog::JSON.decode("")
    end
    tests('{}').returns({}) do
      Fog::JSON.decode('{}')
    end
    tests('[]').returns([]) do
      Fog::JSON.decode('[]')
    end
  end
end

