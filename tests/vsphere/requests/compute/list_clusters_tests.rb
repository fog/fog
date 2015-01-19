Shindo.tests('Fog::Compute[:vsphere] | list_clusters request', ['vsphere']) do
  tests("When listing all clusters") do

    response = Fog::Compute[:vsphere].list_clusters
    test("Clusters extracted from folders... ") {response.length == 4}

    tests("The response data format ...") do
      test("be a kind of Hash") { response.kind_of? Array }
    end
  end
end