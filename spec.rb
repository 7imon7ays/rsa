require 'rspec'
require './rsa'

describe "rsa" do
  it "encrypts and decrypts numeric messages up to 3126\
  using 53 and 59 as primes" do
    prime_a, prime_b, message = 53, 59, 3126
    test_encryption_with_values(prime_a, prime_b, message)
  end

  it "encrypts and decrypts messages greater than 3126" do
    prime_a, prime_b, message = 53, 59, 3127
    test_encryption_with_values(prime_a, prime_b, message)
  end

  it "works using primes less than 53 and 59" do
    prime_a, prime_b, message = 37, 47, 500
    test_encryption_with_values(prime_a, prime_b, message)
  end

  it "works using primes greater than 53 and 59" do
    prime_a, prime_b, message = 61, 67, 500
    test_encryption_with_values(prime_a, prime_b, message)
  end
end

def test_encryption_with_values(prime_a, prime_b, message)
  rsa_user = RsaUser.new(prime_a, prime_b)
  client = RsaClient.new(rsa_user.modulo, rsa_user.public_exponent)
  encoded_message = client.encrypt(message)
  decoded_message = rsa_user.decrypt(encoded_message)
  expect(decoded_message).to eq(message)
end

