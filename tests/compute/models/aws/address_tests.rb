Shindo.tests("AWS::Compute | address", ['aws']) do

  model_tests(AWS[:compute].addresses, {}, true) do
                 
    @server = AWS[:compute].servers.create(:image_id => GENTOO_AMI)
    @server.wait_for { ready? }

    tests('#server=').succeeds do
      @instance.server = @server
    end

    @server.destroy

  end

end
