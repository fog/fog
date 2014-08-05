Shindo.tests("Fog::DNS[:dreamhost] | zone", ['dreamhost', 'dns']) do

  service = Fog::DNS[:dreamhost]
  zone = service.zones.first

  tests('#attributes') do
    tests('should have') do
      model_attribute_hash = zone.attributes
      attributes = [
        :domain,
        :id,
      ]
      attributes.each do |attribute|
        test("#{attribute} method") { zone.respond_to? attribute }
      end
      attributes.each do |attribute|
        test("#{attribute} key") { model_attribute_hash.key? attribute }
      end
    end

    test('be a kind of Fog::DNS::Dreamhost::Zone') do
      zone.kind_of? Fog::DNS::Dreamhost::Zone
    end

    tests('Write operations') do
      name = "#{test_domain}"
      tests('#save') do
        # Does not capture the exception for some reason
        #raises(NotImplementedError, 'raises NotImplementedError') do
        #  service.zones.create :domain => name
        #end
        test 'raises NotImplementedError' do
          begin
            service.zones.create :domain => name
            false
          rescue NotImplementedError => e
            true
          end
        end
      end
      tests('#destroy') do
        test 'raises NotImplementedError' do
          begin
            zone.destroy
            false
          rescue NotImplementedError => e
            true
          end
        end
      end

      tests('#records') do
        zone.records.each do |r|
          test('list records') { r.is_a? Fog::DNS::Dreamhost::Record }
          test('zone matches') { r.zone == test_domain }
        end
      end
    end
  end

end
