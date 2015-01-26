Shindo.tests('Fog::Compute[:cloudsigma] | volumes collection', ['cloudsigma']) do
  volumes = Fog::Compute[:cloudsigma].volumes
  volume_create_args = {:name => 'fogtest', :size => 1024**3, :media => :cdrom}

  collection_tests(volumes, volume_create_args, true) do
    @instance.wait_for(timeout=60) { status == 'unmounted' }
  end

end
