Shindo.tests('Fog::Google[:sql] | tiers model', ['google']) do
  @tiers = Fog::Google[:sql].tiers

  tests('success') do

    tests('#all').succeeds do
      @tiers.all
    end

  end

end
