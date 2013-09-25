require 'fog/cloudstack'
require 'fog/compute'

describe "My behaviour" do

  it "should do something" do

    #To change this template use File | Settings | File Templates.
    cloudstack = Fog::Compute.new(
        :provider =>           'Cloudstack',
        :cloudstack_host=>     '172.17.13.188',
        :cloudstack_port=>     '8080',
        :cloudstack_scheme=>   'http',
        :cloudstack_api_key=>  'C1aCo8A5J_fqiTbTv9Tj9MlU-8tTO2aOJeb4XFYciDl9TK9OGAHE71Yb9ZXsp8L9-Lt3OBWiF9chEDEjQEI74Q',
        :cloudstack_secret_access_key=> 'worQERQsTaor80zPdJGvxlPoLSrHJiPefftpZut_OYJkaQ6ygCB03aiK1ahqqKTXBNUEQml-rSLU-n-5hnL5ag'
    )
    ipaddresses = cloudstack.ipaddresses
    #puts (ipaddresses)
    #ipaddress = cloudstack.ipaddresses.new(options={'networkid' => "eeb3f852-5b68-4793-a5c6-f243d8858172"})
    #addresses = ipaddress.addresses
    #puts(addresses)
    ipaddresses.each do |address|
      puts (address.ip_address)
    end
    #address = addresses.find{ |ip| ip.ipaddress == '172.17.13.231'}
    #puts(address)
  end
end