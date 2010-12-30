Shindo.tests('Linode::DNS | zones collection', ['linode']) do

  zones_tests(Linode[:dns], {}, false)

end
