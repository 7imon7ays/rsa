require 'prime'

# breaks down at 3127 for primes 53 and 59
class RsaUser
  attr_reader :modulo, :public_exponent

  def initialize(prime_a, prime_b)
    [prime_a, prime_b].each do |arg|
      raise ArgumentError, "#{arg} isn't prime." unless Prime.prime?(arg)
    end
    @prime_a = prime_a
    @prime_b = prime_b
    @modulo = @prime_a * @prime_b
    @phi_of_modulo = (@prime_a - 1) * (@prime_b - 1)
    @public_exponent = calc_public_exponent
    @private_exponent = calc_private_exponent
  end

  def decrypt(encoded_message)
    (encoded_message ** @private_exponent) % @modulo
  end

  private

  def calc_public_exponent
    3.upto(1.0/0) do |i|
      return i if i.odd? && co_prime?(@modulo, i)
    end
  end

  def calc_private_exponent
    (2 * @phi_of_modulo + 1) / @public_exponent
  end

  def co_prime?(a, b)
    a.gcd(b) == 1
  end

  # unused because provided nums are assumed to be prime
  def phi(n)
    return n - 1 if Prime.prime?(n)
    (0...n).reduce(0) do |tots_count, i|
      co_prime?(n, i) ? tots_count + 1 : tots_count
    end
  end
end

class RsaClient
  def initialize(modulo, public_exponent)
    @modulo = modulo
    @public_exponent = public_exponent
  end

  def encrypt(message)
    (message ** @public_exponent) % @modulo
  end
end

