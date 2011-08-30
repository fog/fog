Shindo.tests('Fog::Compute[:vsphere] | current_time request', ['vsphere']) do

  compute = Fog::Compute[:vsphere]

  tests('is a Time object').succeeds do
    pending if Fog.mock?
    compute.current_time.is_a?(Time)
  end

end
