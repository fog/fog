Shindo.tests('test_helper', 'meta') do

  tests('#has_error') do

    tests('returns true') do

      test('when expected error is raised') do
        has_error(StandardError) { raise StandardError.new }
      end

    end

    tests('returns false') do

      test('when no error is raised') do
        !has_error(StandardError) {}
      end

      test('when a different error is raised') do
        begin
          !has_error(StandardError) { raise Interrupt.new }
          false
        rescue Interrupt
          true
        end
      end

    end

  end

  tests('#has_format') do

    tests('returns true') do

      test('when format of value matches') do
        has_format({:a => :b}, {:a => Symbol})
      end

      test('when format of nested array elements matches') do
        has_format({:a => [:b, :c]}, {:a => [Symbol]})
      end

      test('when format of nested hash matches') do
        has_format({:a => {:b => :c}}, {:a => {:b => Symbol}})
      end

    end

    tests('returns false') do

      test('when format of value does not match') do
        !has_format({:a => :b}, {:a => String})
      end

      test('when not all keys are checked') do
        !has_format({:a => :b}, {})
      end

      test('when some keys do not appear') do
        !has_format({}, {:a => String})
      end

    end

  end

end
