Shindo.tests('Fog::Compute[:ovirt] | cluster model', ['ovirt']) do

  clusters = Fog::Compute[:ovirt].clusters
  cluster = clusters.last

  tests('The cluster model should') do
    tests('have the action') do
      test('reload') { cluster.respond_to? 'reload' }
      %w{ networks }.each do |action|
        test(action) { cluster.respond_to? action }
      end
    end
    tests('have attributes') do
      model_attribute_hash = cluster.attributes
      attributes = [ :id,
        :name]
      tests("The cluster model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { cluster.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Ovirt::Cluster') { cluster.kind_of? Fog::Compute::Ovirt::Cluster }
  end

end
