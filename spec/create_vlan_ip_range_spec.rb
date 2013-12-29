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
    volume = cloudstack.create_vlan_ip_range(
        :zoneid => '745c3088-4d8d-4198-8b1b-053658596cb9',
        :gateway => '172.17.13.254',
        :netmask => '255.255.255.0',
        :startip => '172.17.13.233',
        :endip => '172.17.13.233',
        :vlan => 'untagged'
    )
  end
end