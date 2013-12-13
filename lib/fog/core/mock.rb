module Fog

  @mocking = false

  def self.mock!
    @mocking = true
  end

  def self.unmock!
    @mocking = false
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

    def self.not_implemented(message = 'Contributions welcome!')
      raise Fog::Errors::MockNotImplemented.new(message)
    end

    def self.random_ip(opts = {:version => :v4})
      version = opts[:version]
      if version == :v6
        bit_length = 128
        family = Socket::AF_INET6
      elsif version == :v4
        bit_length = 32
        family = Socket::AF_INET
      else
        raise ArgumentError, "Unknown IP version: #{version}"
      end

      seed = 1 + rand((2**bit_length)-1)
      IPAddr.new(seed, family).to_s
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

    def self.random_letters_and_numbers(length)
      random_selection(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
        length
      )
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
      mocked_services = []
      Fog.constants.map do |x|
        x_const = Fog.const_get(x)
        x_const.respond_to?(:constants) && x_const.constants.map do |y|
          y_const = x_const.const_get(y)
          y_const.respond_to?(:constants) && y_const.constants.map do |z|
            if z.to_sym == :Mock
              mocked_services << y_const.const_get(z)
            end
          end
        end
      end

      for mocked_service in mocked_services
        next unless mocked_service.respond_to?(:reset)
        mocked_service.reset
      end
    end

  end

end
