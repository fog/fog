Shindo.tests("Fog::Compute[:fogdocker] | image_search request", 'fogdocker') do

  compute = Fog::Compute[:fogdocker]

  tests("Search images") do
    response = compute.image_search('term' => 'test')
    test("should be a kind of Array") { response.kind_of?  Array}
    test("Array elements should be a kind of Hash") { response.first.kind_of?  Hash}
    test("response elemetns should have a name") { !response.first['name'].nil? && !response.first['name'].empty? }
  end
end
