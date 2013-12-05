Shindo.tests('AWS::Storage | delete_multiple_objects', ['aws']) do
  @directory = Fog::Storage[:aws].directories.create(:key => 'fogobjecttests-' + Time.now.to_i.to_s(32))

  tests("doesn't alter options") do
    options = {:quiet => true, 'versionId' => {'fog_object' => '12345'}}
    Fog::Storage[:aws].delete_multiple_objects(@directory.identity, ['fog_object'], options)

    test(":quiet is unchanged") { options[:quiet] }
    test("'versionId' is unchanged") { options['versionId'] == '12345' }
  end
end
