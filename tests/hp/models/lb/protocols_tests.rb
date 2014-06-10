Shindo.tests('HP::LB | protocol collection', ['hp', 'lb', 'protocol']) do

  tests('success') do

    tests('#all').succeeds do
      HP[:lb].protocols
    end

    tests('#get("HTTP")').succeeds do
      HP[:lb].protocols.get('HTTP')
    end

  end

end
