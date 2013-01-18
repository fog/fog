Shindo.tests("Fog::Compute[:aws] | vpc", ['aws']) do

  model_tests(Fog::Compute[:aws].vpcs, {:cidr_block => '10.0.10.0/28'}, true)
end
