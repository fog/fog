Shindo.tests('HP::LB | algorithms collection', ['hp', 'lb', 'algorithms']) do

  tests('success') do

    tests('#all').succeeds do
      HP[:lb].algorithms
    end

    tests('#get("ROUND_ROBIN")').succeeds do
      HP[:lb].algorithms.get("ROUND_ROBIN")
    end

  end

end
