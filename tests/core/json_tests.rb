Shindo.tests('Fog#JSON', 'core') do

TEST_HASH = {'quantity' => 4}
VALID_JSON = "{\"quantity\":4}"

  tests('LegacyJSON') do

    begin
      require 'json'
    rescue => e
      returns('Failed to load JSON library', true) { false }
    end

    pending? unless defined? ::JSON

    class LegacyJSONTester
      include Fog::JSON::LegacyJSON
    end

    @tester = LegacyJSONTester.new
    tests('encode').returns(VALID_JSON) do
      @tester.encode(TEST_HASH)
    end

    tests('decode').returns(TEST_HASH) do
      @tester.decode(VALID_JSON)
    end

    tests('invalid decode').raises(Fog::JSON::LoadError) do
      @tester.decode("I am not json")
    end
  end

  tests('NewJSON') do

    begin
      require 'multi_json'
    rescue => e
      returns('Failed to load multi_json library', true) { false }
     end

     pending unless defined? ::MultiJson

    class NewJSONTester
      include Fog::JSON::NewJSON
    end

    @tester = NewJSONTester.new
    tests('encode').returns(VALID_JSON) do
      @tester.encode(TEST_HASH)
    end

    tests('decode').returns(TEST_HASH) do
      @tester.decode(VALID_JSON)
    end

    tests('invalid decode').raises(Fog::JSON::LoadError) do
      @tester.decode("I am not json")
    end

  end
end