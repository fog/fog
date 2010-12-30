Shindo.tests('Slicehost::DNS | records collection', ['slicehost']) do

  records_tests(Slicehost[:dns], {}, false)

end
