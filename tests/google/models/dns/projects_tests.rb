Shindo.tests('Fog::DNS[:google] | projects model', ['google']) do
  @projects = Fog::DNS[:google].projects

  tests('success') do

    tests('#get').succeeds do
      @projects.get(Fog::DNS[:google].project)
    end

  end

end
