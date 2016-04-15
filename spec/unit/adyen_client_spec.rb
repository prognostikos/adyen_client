require "securerandom"
require_relative "../spec_helper.rb"

describe AdyenClient, vcr: { per_group: true } do
  # These encrypted card strings are taken form the client_side_encryption.html example in the root of the project directory
  let(:encrypted_card) { "adyenjs_0_1_15$hAOv0nb0eX7hmXpvT5dK/obqbUjMaOIvJGA64m0cmn6VTZDBGco2EvY5/2SPXrty23kBQzZsUlO+KF8BR9kXTi4p2+Jky8RDywJqamkb5Y/6oSl7oU4p9WMN5APYjOfDseBT2GkibdYADSPGWatrKAYrn2t0S9qZkGriP9IxLhlwq9D8N/n9AWeOe4p0Aidr0NDm6KDxJZY7N67fSl55+Mu0jsiXE6fbQ03Mdtx8UNhMVHcANS8XH3OOwZk9dZMlkIOJDi7OgKbE0ZfqABh/VfhFzsJpZHKD508tCUB/90bY917A9mbIWgKSnxdYeSBh7T0+2QCGFBllR1vh4NgfAA==$wu1r67pMH3Z3zKVpbCXksyUkRrOlMeeFI9Fpz2G2df4Ad+gGD1+Gmzu0gD3H/F3B3BGwkF9Yqb2LJmyNRBLu2EkdoHBmb81cSTBpwnxRQ086aedugXUBp7Z+ZDt5eP6LhiJfBTN1RO56EDqxYUvIZ6hDBv/U272ZFPbVrLBAaz/RYbK/W4S8zK8pZ5UZq8g7Oo7qoumsdendhH2PfYpPm4rD/xFeMoxOwuYgVCqXIAsBKvJiuhDWdveUhCKC08uf8hrGtozP/rdl9vOIozjmA7NjZaYSatd5nD9p99sQMR/qHzAhi/tA9qchEqr85PbCDjWCrHqgy0Od3CFo/nmMFRHQFKb/qys=" }
  let(:encrypted_card_wrong_cvc) { "adyenjs_0_1_15$lY7ZOXDCOw9oVuWTlGfuKdped5Hpf3nC/Lop79mZJ1VJqbx1Bl2+tf/BD1A2E0lled4NDpvZwpPfy9nux1MOZncgH4LP1aiWwYg1VcWBUBm1k1tN3gx7ZLUqDkuXHOyYfculgx1h/9R9hzwu4CQsMycLnnbjlWSAvGUchaZ4Ii6pmgTITvEzPK1N4vEaezRX9nSKKWbcTfA2jiDrqhPVvgr/aG4/e74TdVxcL4aWdeQFTLjQTeUB3fCn/SkJbKfwKlpC80IDGD9xrw2nWV6I+wB+bZ6vmSt2qoupTzeh9IbTOgFPtYboNjZFKaTL19tGf8UMagvR+o6FCmSVgsQSMQ==$/dSz2IDqi7XkEkYCktRZuUDZV51dbpOuyqXTNDDxUjBKYzKAm0knujDTxPVIoMhoRNJuN0jdeBUCLhl2R2J1kED1z9grgYJZqRoDUjaBJ33g1YP8Go8pi7rOBzOVkX1+TnH5/5CdB8S6kRH9bjOQRRMbfgOhyAFmIqQ6lF8WiLamYjLY59wwaHq0+QYQVkBjKHaYjW6pPGr97iEnayOg72oeMnuDj59yKXZf2/sovtXKu4S7t5pEVwP+G19vwoERbaEXKd+j7aWIPVXbjS1Xs0Sn7/c3B/X5HclNOioeddJ+RJbiRos3yC3eLBlxe/PVgW//v0wsB4TbpPwVYyvWjRTetvyQ8tKFiVfayMckOFGd+ws9gRQPSjqlxVStl5n40yO1e2UP4g==" }
  let(:encrypted_card_wrong_exp) { "adyenjs_0_1_15$FEkA9DPTolK/s4PgIsW01NLX5z9otU4/n/evEqKJ5U7dPkZqHqLVXLwCHMmHr26XD+6N6H2S+etOKnaBgfKEkgckgcBPuXBTDYuHwSPa0dHudY7MpLTrlSEPgvy5VpT1WP74tixB5bxjovDULN1dVGrlw9LssNfRBj9laxTevrUAF/1GUDoeBSu45SUFNzZjkFUjDQan4XJlaAb5vexeLqiYIAW050MoW6iSxG0yM4GWMMPFvwfGVJEnYZJn3mhg7/uLw7y4Wyu7//sVVL4crIGvprwe8UNfsYBN3HzDqZwf1TdrOEn+TuyfqYWZbjN8U4oMK/Zq7q2cwP7a51A1bw==$GZe8zeZzVdi9VJDQdo940MO17kAF9/XE1iepfxghPW0TtWmdH7WktjlunA9RlW9CvNvpVgetJFJUB8PQd3fCl2GtcCO0Jx/gnhdL5RoAn5hAOCitB77ojP+qE9Dq1ZyfNkRUcs2b0D3IHz0W6IBvRwv3E7M9NCy2Sjskwqkyg8kY30pcggdp225+UDK9Xm4oHevu82C3A9WtXDCFjQ9S/5WEGvNAKIslAsBDgIOvE/lYQWcVOQ+6Dkr685A+dUD/lKd5q6a6fWRZo/fxQ4EyKzfrw61HA0UgsjZdZoqfbLk8JdtgLQKUrMup1RXQW5/MK5YXS6HIUiUx8QQZO8q9z4CpJpZZYrvyw2Se12EFhYAdfOBVvBiKdSLzaAocQysRbjWMiTSvMg==" }
  let(:encrypted_card_garbled) { encrypted_card.gsub(/[abc]/, "x") }
  let(:shopper) { Hash[email: "john@doe.com", ip: "127.0.0.1", reference: "john"] }
  let(:client) { AdyenClient.new }

  # very helpful when running tests against the live api
  # using it produces early failures showing the errors
  def assert_no_errors_in_response
    assert_equal [nil, nil], response.data.values_at("error_type", "message")
  end

  describe "#verify" do
    describe "authorised" do
      let(:response) { client.verify(amount: 123, encrypted_card: encrypted_card, reference: SecureRandom.uuid) }
      before { assert_no_errors_in_response }

      it "should return an authorised response with valid data" do
        assert response.authorised?
      end

      it "should include the psp_reference in the response" do
        # taken from spec/cassettes/AdyenClient/verify/successful.yml
        assert_equal "7914607123875349", response.psp_reference # taken from vcr cassette
      end
    end

    describe "refused" do
      let(:response) { client.verify(amount: 123, encrypted_card: encrypted_card_wrong_cvc, reference: SecureRandom.uuid) }

      it "should not be authorised" do
        assert ! response.authorised?
      end

      it "should have a refusal reason" do
        assert_equal "CVC Declined", response.refusal_reason
      end
    end
  end

  describe "#authorise" do
    describe "authorised" do
      let(:response) { client.authorise(amount: 123, encrypted_card: encrypted_card, reference: SecureRandom.uuid) }
      before { assert_no_errors_in_response }

      it "should return an authorised response" do
        assert response.authorised?
      end

      it "should include the psp_reference in the response" do
        assert_equal "8514607123884459", response.psp_reference # taken from vcr cassette
      end
    end

    describe "refused" do
      let(:response) { client.authorise(amount: 123, encrypted_card: encrypted_card_wrong_cvc, reference: SecureRandom.uuid) }

      it "should not be authorised" do
        assert ! response.authorised?
      end

      it "should have a refusal reason" do
        assert_equal "CVC Declined", response.refusal_reason
      end
    end
  end

  describe "#capture" do
  end

  describe "#cancel" do
  end

  describe "#refund" do
  end

  describe "#cancel_or_refund" do
  end

  describe "#create_recurring_contract" do
    describe "authorised" do
      let(:response) { client.create_recurring_contract(encrypted_card: encrypted_card, shopper: shopper, reference: SecureRandom.uuid) }
      before { assert_no_errors_in_response }

      it "should return an authorised response" do
        assert response.authorised?
      end

      it "should include the psp_reference in the response" do
        assert_equal "8514607123874435", response.psp_reference # taken from vcr cassette
      end
    end
  end

  describe "#list_recurring_details" do
    let(:response)  { client.list_recurring_details(shopper_reference: shopper[:reference]) }
    let(:contract) { response.details.first }

    it "should return a response with the shopper_reference" do
      assert_equal shopper[:reference], response.shopper_reference
    end

    it "should return a contract with a recurring detail reference" do
      assert_equal "8314508657181050", contract["recurring_detail_reference"]
    end
  end

  describe "#authorise_recurring_payment" do
    describe "authorised" do
      let(:response) { client.authorise_recurring_payment(amount: 456, reference: SecureRandom.uuid, shopper_reference: shopper[:reference]) }
      before { assert_no_errors_in_response }

      it "should return an authorised response" do
        assert response.authorised?
      end

      it "should include the psp_reference in the response" do
        assert_equal "8814607123882153", response.psp_reference # taken from vcr cassette
      end
    end
  end

end
