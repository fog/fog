Shindo.tests("AWS::Compute | snapshot", ['aws']) do

  @volume = AWS[:compute].volumes.create(:availability_zone => 'us-east-1a', :size => 1)
  @volume.wait_for { ready? }

  model_tests(AWS[:compute].snapshots, {:volume_id => @volume.identity}, true)
                    
  @volume.destroy

end