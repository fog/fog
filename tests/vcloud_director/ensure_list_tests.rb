Shindo.tests('Compute::VcloudDirector | ensure_list!', ['vclouddirector']) do

  # ensure list is not available in mocking mode
  unless Fog.mocking?

    @service = Fog::Compute::VcloudDirector.new

    tests('#ensure_list! for single key') do
      tests('for key with a hash').returns(Array) do
        testdata = {:k => {:A => '1'}}
        @service.ensure_list!(testdata, :k)
        testdata[:k].class
      end

      tests('for key with empty array').returns(Array) do
        testdata = {:k => []}
        @service.ensure_list!(testdata, :k)
        testdata[:k].class
      end

      tests('for key with nothing').returns(Array) do
        testdata = {}
        @service.ensure_list!(testdata, :k)
        testdata[:k].class
      end

      tests('for key with non-empty array').returns(Array) do
        testdata = {:k => ['one', 'two']}
        @service.ensure_list!(testdata, :k)
        testdata[:k].class
      end
    end

    tests ('#ensure_list! for nested keys') do
      tests('with no key').returns(Array) do
        testdata = {}
        @service.ensure_list!(testdata, :keys, :key)
        testdata[:keys][:key].class
      end

      tests('with empty string').returns(Array) do
        testdata = {:keys => ''}
        @service.ensure_list!(testdata, :keys, :key)
        testdata[:keys][:key].class
      end

      tests('with nested hashes').returns(Array) do
        testdata = {:keys => {:key => {:a => '1'}}}
        @service.ensure_list!(testdata, :keys, :key)
        testdata[:keys][:key].class
      end
    end

  end

end
