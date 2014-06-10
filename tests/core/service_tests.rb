Shindo.tests('Fog::Service', ['core']) do

  class TestService < Fog::Service
    recognizes :generic_user, :generic_api_key

    class Real
      attr_reader :options

      def initialize(opts={})
        @options = opts
      end
    end

    class Mock < Real
    end
  end

  tests('Properly passes headers') do
    user_agent = 'Generic Fog Client'
    params = { :generic_user => "bob", :generic_api_key => '1234', :connection_options => {:headers => { 'User-Agent' => user_agent }}}
    service = TestService.new(params)

    returns('User-Agent' => user_agent) { service.options[:connection_options][:headers] }
  end

end
