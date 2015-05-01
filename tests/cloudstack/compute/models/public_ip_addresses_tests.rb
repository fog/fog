Shindo.tests("Fog::Compute[:cloudstack] | public_ip_addresses", ['cloudstack']) do

    collection_tests(Fog::Compute[:cloudstack].public_ip_addresses, {}, true)

end
