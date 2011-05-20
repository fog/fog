module Fog

  @mocking = false

  def self.mock!
    @mocking = true
  end

  def self.mock?
    @mocking
  end

  def self.mocking?
    @mocking
  end

  module Mock

    @delay = 1
    def self.delay
      @delay
    end

    def self.delay=(new_delay)
      raise ArgumentError, "delay must be non-negative" unless new_delay >= 0
      @delay = new_delay
    end

    def self.not_implemented
      raise Fog::Errors::MockNotImplemented.new("Contributions welcome!")
    end

    def self.random_base64(length)
      random_selection(
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
        length
      )
    end

    def self.random_hex(length)
      max = ('f' * length).to_i(16)
      rand(max).to_s(16).rjust(length, '0')
    end

    def self.random_letters(length)
      random_selection(
        'abcdefghijklmnopqrstuvwxyz',
        length
      )
    end

    def self.random_numbers(length)
      max = ('9' * length).to_i
      rand(max).to_s
    end

    def self.random_selection(characters, length)
      selection = ''
      length.times do
        position = rand(characters.length)
        selection << characters[position..position]
      end
      selection
    end

    def self.reset
      providers = Fog.providers.map {|p| Fog.const_get(p) }
      possible_service_constants = providers.map {|p| p.constants.map {|c| p.const_get(c) } }.flatten
      # c.to_sym is 1.8.7 / 1.9.2 compat
      services = possible_service_constants.select {|s| s.constants.map {|c| c.to_sym }.include?(:Mock) }
      service_mocks = services.map {|s| s.const_get(:Mock) }

      service_mocks.each do |service_mock|
        next unless service_mock.respond_to?(:reset)
        service_mock.reset
      end
    end

  end

end
