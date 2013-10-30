Shindo.tests("HP::BlockStorage | volumes collection", ['hp', 'v2', 'block_storage', 'volumes']) do

  collection_tests(HP[:block_storage_v2].volumes, {:name => 'fogvol2tests', :description => 'fogvol2tests-desc', :size => 1}, true)

end
