module Spec
  module Matchers
    class Eventually #:nodoc:
      def initialize(&block)
        @block = block
      end

      def matches?(given_proc)
        match = nil
        [0,2,4,8,16].each do |delay|
          begin
            sleep(delay)
            match = @block[given_proc.call]
            break
          rescue Spec::Expectations::ExpectationNotMetError => error
            raise error if delay == 16
          end
        end
        match
      end
    end

    # :call-seq
    #   should eventually() { |expected| ... }
    # Matches if block matches within 30 seconds
    #
    # == Examples
    #
    #   lambda { do_something_eventually_returning_true }.should eventually {|expected| expected.should be_true }
    #
    #   lambda { do_something_eventually_returning_false }.should_not eventually {|expected| expected.should_not be_true }
    def eventually(&block)
      Matchers::Eventually.new(&block)
    end
  end
end
