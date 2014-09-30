Shindo.tests('Fog::Google[:monitoring] | metric_descriptors model', ['google']) do
  @metric_descriptors = Fog::Google[:monitoring].metric_descriptors

  tests('success') do

    tests('#all').succeeds do
      @metric_descriptors.all
    end

  end

end
