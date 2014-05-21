Shindo.tests("Fog::DNS[:dreamhost] | record", ['dreamhost', 'dns']) do

  service = Fog::DNS[:dreamhost]
  record  = service.records.first

  tests('#attributes') do
    tests('should have') do
      model_attribute_hash = record.attributes
      attributes = [
        :name,
        :value,
        :zone,
        :type,
        :editable,
        :account_id,
        :comment,
      ]
      attributes.each do |attribute|
        test("#{attribute} method") { record.respond_to? attribute }
      end
      attributes.each do |attribute|
        test("#{attribute} key") { model_attribute_hash.key? attribute }
      end
    end

    test('be a kind of Fog::DNS::Dreamhost::Record') do
      record.kind_of? Fog::DNS::Dreamhost::Record
    end

    tests('Write operations') do
      name = "test.#{test_domain}"
      r = service.records.create :name  => name,
                                 :type  => 'A',
                                 :value => "8.8.8.8"
      sleep 10
      tests('#save') do
        test('returns Fog::DNS::Dreamhost::Record') do
          r.is_a? Fog::DNS::Dreamhost::Record
        end
        test('value is 8.8.8.8') do
          r.value == '8.8.8.8'
        end
        test("name is #{name}") do
          r.name == name
        end
        test("listed") do
          !(service.records.find { |r| r.name == name }).nil?
        end
      end
      tests('#destroy') do
        test('returns true') { r.destroy == true }
        test('destroyed record not listed') do
          (service.records.find { |r| r.name == name }).nil?
        end
      end
      tests('#save from zone') do
        name = "zone-create.#{test_domain}"
        r = service.zones.first.records.create :name  => name,
                                               :type  => 'A',
                                               :value => "8.8.8.8"
        sleep 10
        test("listed") do
          !(service.records.find { |r| r.name == name }).nil?
        end
      end
    end
  end

  # cleanup
  cleanup_records

end
