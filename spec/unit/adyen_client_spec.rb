require "securerandom"
require_relative "../spec_helper.rb"

describe AdyenClient, vcr: { per_group: true } do
  # These encrypted card strings are taken form the client_side_encryption.html example in the root of the project directory
  let(:encrypted_card) { "adyenjs_0_1_15$IQ86J/plzJhF5JJG7ShX6fndrfc4N4Xq+8exBzWvAoBuiFSUz4oKoDXj0UMtXPLNuvQJfXYmDBqTKy6ZtYsM76PFYAe4dGu1e6JDm+2RWX4VKLDQQ3cDEyRNlPjb7ac4X9HUnBuFoYmyITYLe8RlKbOqLCKLihG3AY6j6YbDjpH2AUAYYdz5UVECgJUcyEnCEI0Tq1s82CqqRs0mDe39SLkL9LBWLMydtQTrs5ovTrA5Bl0hb93urYe6ExUZkzccK/cjWaoKU8zKMeCTxWGMDM2nzbHOme/Cn6nMoRssORtETJC5YroDhviL/FbVGFl155w+e41PjSNmj/sImQBJgg==$m5ac+At3NQRJz6WCm1aSGi3IfWXibHpu88+ZHG5Qqg3UiEMh5/Ix7Qw1nd9Eahuac/rRAgu5SjH+elRfi44uZNEcAPjRmObJs0T/n3G8ihg9oWmDkczntr3H4Ge11V+zqZrKxXED/eZSfsfyAlw5NptefqPwnmA6pYFQc+1/zVtyXwgYhkNIhocogdivv0IIdmRUUQ2cLXmk+VWrwBjHN9MFCzddflv9YzWugO9V0BhMhYDQKOcj3PEe0b8BDWB443n302rHGUQDjRczkmUm/iElQYXWIQ7FkidgIfeRMg82mUx+bLCNExq5abHrC1GMeETR10zQRR5dzubeLu18i140zVxZydU=" }
  let(:encrypted_card_wrong_cvc) { "adyenjs_0_1_15$P72PfRV1kT0p/yvtEuOrDTr6bCgEK2DJFNLEeW9B0cW9XRPzW9kUv9zL+oZAKTQ5/mZ+DmV26+YIlS7u2OkMPFxx7r/0HBJS8r35hA9F9UgnjbU/EvUKByvii4YEQuksVvq8o4tDv/Cu/WlrVKg2SkE0Do4Kz5QeNvoDsPlR6D3241fsae1DrjfXV/JRKfr8XfhfnS5SGsNpVcWuBNVzBsgJqblmuPEX7QdnoJiRmLXCVJch0iUAN+dlpQYYBiKv2sqmblIzI/NAVxsl/VCDSWQTUIbLguUzdFUkdA+ilME3LXnK5A44iOrx0sLX0deZNsRv11dDlKqGl4ig7RKPtw==$vYi0R3R+BJchqcApxd9LioLYWT199urvgAhs9wWGweCyLs+pgmuwoU0ozK3gV0jY5MmaNWW+WL2aZvw6qFLZeSwNL6jK6nLCoaYYqQ3Sp+i1hv9Yjbk40NQxq6Riq3rD+kYPDLI6hIp0rsR9paGMmaKlyW9K8/1l5t1BmeARsXbMz7gpw0qd+cqPkLVdxozCETvTudRpWxBPJHw6AT1ofZVo1UVyKAjdsdzOnT8zOX6lF16PnRmVw8ItVz4v1DhO7Jo2IhUWoI1q3mHvtYdLloCPI3ArZnLXNNjf95PSIYe7QNlPcVAzoj1WNkrvcVpji922o25eZW16N93xkOHJU7efkeXwOJj72S0DWIhcwt5DAauBXgbc/YMlR0AOdzQiy8TsCmNb8Q==" }
  let(:encrypted_card_wrong_exp) { "adyenjs_0_1_15$dp9SlsA+dQP2Gg5RCgKv26N7blzXnbkRfNR0s5K4pPz3OYtpmLWHMn358RE/S1Auwpyr/WxH90hjl+cjXTSNEOVFtKEd6R9dHBWIpzuPBjqIgnedrEIxEZ2vI50lhfVi503ey1A6eSxe39MOUZvgj4jlzXZs1eB67dLWeqfWFaAbZ8NwUteJ/PZ7DQxXmy8OqeiqY7ToLZYs+bZPVHFZQDCp/FUG9HW8LTMGcpSTtk2Fw+y6b53mX0jyk/5AjAqenHHLJwNRdV1NIVqn8xLK9hp7bqrXh5jK8cNa6Phk2RRJ4IC10UYRfM0Wg+6rJg4oLHziR/yRTQhC7GEUZb8upQ==$c8hD0b3x1XGmd3sm9FkG+tfsOyzDK3uYrbZM2ZPdSv5Xh79ascbX6RrnylTc35ypjarYqIjTBuGe7oJLLK/6jzx0zXVnJk/0mSeutFq8QTAN6ywAirZgBS6gzQL4f+AhTprkyO932wKwB1qX0k1apLJOSLupXe5UvqIlABeB8Y6R2drgkmzwuIjJGqyh2+wzjdojbi225/Qos8lCPYg/YY6/+avVtUBhKPjEwe0Vl+QnHOXQE5kkYoT6kSd6Bkh4w5z2syQy4xL+KvYLTLe1Uyr51+Go1x2wT9SLMKaNgDAZmD6N25G0cHZxfjIh8wSWHwwsKBY9a8WarqwoRac1kCsaFuONLdI=" }
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
        assert_equal "8614508646223531", response.psp_reference # taken from vcr cassette
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
        assert_equal "7914508644691928", response.psp_reference # taken from vcr cassette
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
        assert_equal "7914508657186147", response.psp_reference # taken from vcr cassette
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
        assert_equal "8514508661603766", response.psp_reference # taken from vcr cassette
      end
    end
  end

end
