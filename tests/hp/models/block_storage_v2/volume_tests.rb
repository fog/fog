Shindo.tests("HP::BlockStorage | volume model", ['hp', 'v2', 'block_storage', 'volumes']) do

  model_tests(HP[:block_storage_v2].volumes, {:name => 'fogvol2tests', :description => 'fogvol2tests-desc', :size => 1}, true) do

    test("get(#{@instance.id})") do
      HP[:block_storage_v2].volumes.get(@instance.id) != nil?
    end

    test("update(#{@instance.id})") do
      @instance.name = 'fogvol2tests Updated'
      @instance.save
      @instance.reload
      @instance.name == 'fogvol2tests Updated'
    end

    test("has_attachments?") do
      @instance.has_attachments? == false
    end

  end

end
