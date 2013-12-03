require 'fog/serverlove/util/compute/password_generator'

Shindo.tests('Fog::Compute::Serverlove::PasswordGenerator | generate password', ['serverlove']) do

  @password = Fog::Compute::Serverlove::PasswordGenerator.generate

  tests("@password.length").returns(8) do
    @password.length
  end
  
  tests("@password contains one capital letter").returns(true) do
    @password.match(/[A-Z]/) && true
  end
  
  tests("@password contains one lower case letter").returns(true) do
    @password.match(/[a-z]/) && true
  end
  
end