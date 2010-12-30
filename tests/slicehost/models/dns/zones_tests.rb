Shindo.tests('Slicehost::DNS | zones collection', ['slicehost']) do

  zones_tests(Slicehost[:dns], {}, false)

end
