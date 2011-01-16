module Shindo
  class Tests

    def succeeds
      test('succeeds') do
        instance_eval(&Proc.new)
        true
      end
    end

  end
end