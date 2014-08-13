Shindo.tests('Fog::Google[:sql] | instance model', ['google']) do
  @instances = Fog::Google[:sql].instances

  tests('success') do

    tests('#create').succeeds do
      @instance = @instances.create(:instance => Fog::Mock.random_letters(16), :tier => 'D1')
      @instance.wait_for { ready? }
    end

    tests('#update').succeeds do
      @instance.activation_policy = 'ALWAYS'
      @instance.update
      @instance.wait_for { ready? }
    end

    tests('#clone').succeeds do
      pending unless Fog.mocking? # Binary log must be activated
      instance_cloned_id = Fog::Mock.random_letters(16)
      @instance.clone(instance_cloned_id, :async => false)
      @instances.get(instance_cloned_id).destroy
    end

    tests('#export').succeeds do
      pending unless Fog.mocking? # We don't have access to a Google Cloud Storage bucket
      @instance.export("gs://#{Fog::Mock.random_letters_and_numbers(16)}/mysql-export", :async => false)
    end

    tests('#import').succeeds do
      pending unless Fog.mocking? # We don't have access to a Google Cloud Storage bucket
      @instance.import("gs://#{Fog::Mock.random_letters_and_numbers(16)}/mysql-export", :async => false)
    end

    tests('#ready?').succeeds do
      @instance.ready? == true
    end

    tests('#reset_ssl_config').succeeds do
      @instance.reset_ssl_config(:async => false)
    end

    tests('#restart').succeeds do
      @instance.restart(:async => false)
    end

    tests('#set_root_password').succeeds do
      @instance.set_root_password(Fog::Mock.random_letters_and_numbers(8), :async => false)
    end

    tests('#destroy').succeeds do
      @instance.destroy
    end

  end

end
