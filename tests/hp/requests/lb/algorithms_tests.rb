Shindo.tests("HP::LB | algorithms", ['hp', 'lb', 'algorithms']) do
  @algo_format = {
    'name' => String
  }

  tests('success') do

    tests('#list_algorithms').formats({'algorithms' => [@algo_format]}) do
      HP[:lb].list_algorithms.body
    end

  end

end
