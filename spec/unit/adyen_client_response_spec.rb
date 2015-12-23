require_relative "../spec_helper.rb"

describe AdyenClient::Response do

  describe "::parse" do
    let(:httparty_response) { stub(code: 200, parsed_response: { "foo" => "bar" }) }
    let(:response) { AdyenClient::Response.parse(httparty_response) }

    it "should initialise code from HTTParty::Response#code" do
      assert_equal 200, response.code
    end

    it "should initialise data from HTTParty::Response#parsed_response" do
      assert_equal({"foo" => "bar"}, response.data)
    end
  end

  let(:response) do
    AdyenClient::Response.new(200,
      "foo_bar" => "zig",
      "object_list" => [
        { "zig_zag" => "zag" },
        { "muh_meh" => "meh" }
      ],
      "single_value" => { "stays_nested" => 123 }
    )
  end

  describe "#success?" do
    it "should return true if the response code equals 200" do
      assert response.success?
    end

    it "should return false if the response code does not equal 200" do
      response = AdyenClient::Response.new(400, {})
      assert ! response.success?
    end
  end

  describe "#authorised?" do
    it "should return true if the response is successful and result_code equals 'Authorised'" do
      response = AdyenClient::Response.new(200, "result_code" => "Authorised")
      assert response.authorised?
    end

    it "should return false if the response was not succesful" do
      response = AdyenClient::Response.new(500, "result_code" => "Authorised")
      assert ! response.authorised?
    end

    it "should return false if result_code does not equal 'Authorised'" do
      response = AdyenClient::Response.new(200, "result_code" => "Refused")
      assert ! response.authorised?
    end
  end

  describe "#respond_to?" do
    it "should return true for all normalised top level keys" do
      assert response.respond_to?(:foo_bar)
      assert response.respond_to?(:object_list)
      assert response.respond_to?(:single_value)
    end

    it "should return false for names that are not top level keys" do
      assert ! response.respond_to?(:zig_zag)
    end
  end

  describe "#method_missing" do
    it "should allow to retreive top level keys" do
      assert_equal({"stays_nested" => 123}, response.single_value)
    end

    it "should raise NoMethodError if the top level key could not be found" do
      assert_raises(NoMethodError) { response.zig_zag }
    end
  end

end

