Shindo.tests("Fog::Compute[:cloudstack] | disk_offering", "cloudstack") do
  config = compute_providers[:cloudstack]
  compute = Fog::Compute[:cloudstack]
  model_tests(compute.disk_offerings, config[:disk_offering_attributes], config[:mocked])
end
