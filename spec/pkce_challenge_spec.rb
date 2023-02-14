# frozen_string_literal: true

require "spec_helper"
require 'base64'

RSpec.describe PkceChallenge do
  describe "#challenge" do
    let(:challenge) { PkceChallenge.challenge }

    it "should be an instance of Challenge" do
      expect(challenge).to be_an_instance_of(PkceChallenge::Challenge)
    end

    it "should have verifier with default char length" do
      expect(Base64.urlsafe_decode64(challenge.code_verifier).length).to equal(48)
    end

    it "should match ABNF described in [RFC 7636](https://tools.ietf.org/html/rfc7636)" do
      max_length_challenge = PkceChallenge.challenge(char_length: 128)
      min_length_challenge = PkceChallenge.challenge(char_length: 43)

      expect(challenge.code_verifier).to match(/^([A-Za-z0-9]|\-|\.|_|~)+$/)
      expect(max_length_challenge.code_verifier).to match(/^([A-Za-z0-9]|\-|\.|_|~)+$/)
      expect(min_length_challenge.code_verifier).to match(/^([A-Za-z0-9]|\-|\.|_|~)+$/)
    end

    it "should raise an error when invalid length is given" do
      expect { PkceChallenge.challenge(char_length: 1) }.to raise_error(PkceChallenge::LengthOutOfRangeError)
    end
  end
end
