Shindo.tests('Fog::Compute[:cloudsigma] | volume model', ['cloudsigma']) do
  volumes = Fog::Compute[:cloudsigma].volumes
  volume_create_args = {:name => 'fogmodeltest', :size => 1024**3, :media => :cdrom}

  model_tests(volumes, volume_create_args, true) do
    @instance.wait_for(timeout=60) { available? }

    tests('#update').succeeds do
      @instance.media = 'disk'
      #@instance.size = 1024**3 # resizes disk
      @instance.save

      @instance.reload
      @instance.wait_for(timeout=60) { available? }

      #returns(1024**3) { @instance.size }
      returns('disk') { @instance.media }
    end
  end

end
