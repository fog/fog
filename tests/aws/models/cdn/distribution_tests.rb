Shindo.tests("Fog::CDN[:aws] | distribution", ['aws', 'cdn']) do
  params = { :s3_origin => { 'DNSName' => 'fog_test_cdn.s3.amazonaws.com'}, :enabled => true }
  model_tests(Fog::CDN[:aws].distributions, params, false) do
    # distribution needs to be ready before being disabled
    tests("#ready? - may take 15 minutes to complete...").succeeds do
      pending if Fog.mocking?

      @instance.wait_for { ready? }
    end

    # and disabled before being distroyed
    tests("#disable - may take 15 minutes to complete...").succeeds do
      pending if Fog.mocking?

      @instance.disable
      @instance.wait_for { ready? }
    end
  end
end
