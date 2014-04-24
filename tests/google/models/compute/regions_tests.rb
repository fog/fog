Shindo.tests("Fog::Compute[:google] | regions model", ['google']) do
  @regions = Fog::Compute[:google].regions

  tests('success') do
    tests('#all').succeeds do
      @regions.all
    end

    tests('#get').succeeds do
      @regions.get @regions.all.first.name
    end
  end

  tests('failure') do
    tests('#get').returns(nil) do
      @regions.get 'unicorn'
    end
  end
end
