Shindo.tests('test_helper', 'meta') do

  tests('#formats backwards compatible changes') do

    tests('when value matches schema expectation') do
      formats({"key" => String}) { {"key" => "Value"} }
    end

    tests('when values within an array all match schema expectation') do
      formats({"key" => [Integer]}) { {"key" => [1, 2]} }
    end

    tests('when nested values match schema expectation') do
      formats({"key" => {:nested_key => String}}) { {"key" => {:nested_key => "Value"}} }
    end

    tests('when collection of values all match schema expectation') do
      formats([{"key" => String}]) { [{"key" => "Value"}, {"key" => "Value"}] }
    end

    tests('when collection is empty although schema covers optional members') do
      formats([{"key" => String}]) { [] }
    end

    tests('when additional keys are passed and not strict') do
      formats({"key" => String}, false) { {"key" => "Value", :extra => "Bonus"} }
    end

    tests('when value is nil and schema expects NilClass') do
      formats({"key" => NilClass}) { {"key" => nil} }
    end

    tests('when value and schema match as hashes') do
      formats({}) { {} }
    end

    tests('when value and schema match as arrays') do
      formats([]) { [] }
    end

    tests('when value is a Time') do
      formats({"time" => Time}) { {"time" => Time.now} }
    end

    tests('when key is missing but value should be NilClass (#1477)') do
      formats({"key" => NilClass}) { {} }
    end

    tests('when key is missing but value is nullable (#1477)') do
      formats({"key" => Fog::Nullable::String}) { {} }
    end

  end

  tests('data matches schema') do
    data = {:welcome => "Hello" }
    data_matches_schema(:welcome => String) { data }
  end

  tests('#confirm_data_matches_schema') do

    tests('returns true') do

      returns(true, 'when value matches schema expectation') do
        confirm_data_matches_schema({"key" => "Value"}, {"key" => String})
      end

      returns(true, 'when values within an array all match schema expectation') do
        confirm_data_matches_schema({"key" => [1, 2]}, {"key" => [Integer]})
      end

      returns(true, 'when nested values match schema expectation') do
        confirm_data_matches_schema({"key" => {:nested_key => "Value"}}, {"key" => {:nested_key => String}})
      end

      returns(true, 'when collection of values all match schema expectation') do
        confirm_data_matches_schema([{"key" => "Value"}, {"key" => "Value"}], [{"key" => String}])
      end

      returns(true, 'when collection is empty although schema covers optional members') do
        confirm_data_matches_schema([], [{"key" => String}], {:allow_optional_rules => true})
      end

      returns(true, 'when additional keys are passed and not strict') do
        confirm_data_matches_schema({"key" => "Value", :extra => "Bonus"}, {"key" => String}, {:allow_extra_keys => true})
      end

      returns(true, 'when value is nil and schema expects NilClass') do
        confirm_data_matches_schema({"key" => nil}, {"key" => NilClass})
      end

      returns(true, 'when value and schema match as hashes') do
        confirm_data_matches_schema({}, {})
      end

      returns(true, 'when value and schema match as arrays') do
        confirm_data_matches_schema([], [])
      end

      returns(true, 'when value is a Time') do
        confirm_data_matches_schema({"time" => Time.now}, {"time" => Time})
      end

      returns(true, 'when key is missing but value should be NilClass (#1477)') do
        confirm_data_matches_schema({}, {"key" => NilClass}, {:allow_optional_rules => true})
      end

      returns(true, 'when key is missing but value is nullable (#1477)') do
        confirm_data_matches_schema({}, {"key" => Fog::Nullable::String}, {:allow_optional_rules => true})
      end

    end

    tests('returns false') do

      returns(false, 'when value does not match schema expectation') do
        confirm_data_matches_schema({"key" => nil}, {"key" => String})
      end

      returns(false, 'when key formats do not match') do
        confirm_data_matches_schema({"key" => "Value"}, {:key => String})
      end

      returns(false, 'when additional keys are passed and strict') do
        confirm_data_matches_schema({"key" => "Missing"}, {})
      end

      returns(false, 'when some keys do not appear') do
        confirm_data_matches_schema({}, {"key" => String})
      end

      returns(false, 'when collection contains a member that does not match schema') do
        confirm_data_matches_schema([{"key" => "Value"}, {"key" => 5}], [{"key" => String}])
      end

      returns(false, 'when hash and array are compared') do
        confirm_data_matches_schema({}, [])
      end

      returns(false, 'when array and hash are compared') do
        confirm_data_matches_schema([], {})
      end

      returns(false, 'when a hash is expected but another data type is found') do
        confirm_data_matches_schema({"key" => {:nested_key => []}}, {"key" => {:nested_key => {}}})
      end

      returns(false, 'when key is missing but value should be NilClass (#1477)') do
        confirm_data_matches_schema({}, {"key" => NilClass}, {:allow_optional_rules => false})
      end

      returns(false, 'when key is missing but value is nullable (#1477)') do
        confirm_data_matches_schema({}, {"key" => Fog::Nullable::String}, {:allow_optional_rules => false})
      end

    end

  end

end
