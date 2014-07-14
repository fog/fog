Shindo.tests("Fog::Compute[:google] | disk_types model", ['google']) do
  @disk_types = Fog::Compute[:google].disk_types

  tests('success') do

    tests('#all').succeeds do
      @disk_types.all
    end

    tests('#get').succeeds do
      disk_type = @disk_types.all.first
      @disk_types.get(disk_type.name)
    end

    tests('failure') do
      tests('#get').returns(nil) do
        @disk_types.get(Fog::Mock.random_letters_and_numbers(16))
      end
    end

  end
end
