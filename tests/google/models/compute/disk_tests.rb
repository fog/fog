Shindo.tests("Fog::Compute[:google] | disk model", ['google']) do

  model_tests(Fog::Compute[:google].disks, {:name => 'fog-disk-model-tests',
                                            :zone => 'us-central1-a',
                                            :size_gb => 10}) do |model|
    Fog.wait_for do 
      model.reload
      model.status != 'CREATING'
    end
  end

end
