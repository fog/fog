Shindo.tests("Fog::Storage[:hp] | directories", ['hp', 'storage']) do

  collection_tests(Fog::Storage[:hp].directories, {:key => "fogdirtests"}, true)

  tests('success') do

    tests("#create('fogdirtests')").succeeds do
      Fog::Storage[:hp].directories.create(:key => 'fogdirtests')
    end

    tests("#head('fogdirtests')").succeeds do
      Fog::Storage[:hp].directories.head('fogdirtests')
    end

    tests("#get('fogdirtests')").succeeds do
      @directory = Fog::Storage[:hp].directories.get('fogdirtests')
    end

    @directory.destroy

  end

end
