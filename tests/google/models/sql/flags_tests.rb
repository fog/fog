Shindo.tests('Fog::Google[:sql] | flags model', ['google']) do
  @flags = Fog::Google[:sql].tiers

  tests('success') do

    tests('#all').succeeds do
      @flags.all
    end

  end

end
