module Shindo
  class Tests
    def responds_to(method_names)
      for method_name in [*method_names]
        tests("#respond_to?(:#{method_name})").returns(true) do
          @instance.respond_to?(method_name)
        end
      end
    end
  end
end
