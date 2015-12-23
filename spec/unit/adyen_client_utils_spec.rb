require_relative "../spec_helper.rb"

describe AdyenClient::Utils do

  describe "::massage_response" do
    let(:data) do
      {
        "fooBar" => "zig",
        "objectList" => [
          {"foo" => { "zigZag" => "zag" }},
          {"foo" => { "muhMeh" => "meh" }}
        ],
        "singleValue" => { "staysNested" => 123 }
      }
    end

    it "should normalise to underscorised keys" do
      assert_equal %w[foo_bar object_list single_value], AdyenClient::Utils.massage_response(data).keys
    end

    it "should remove nested objects from lists of objects" do
      assert_equal [{"zig_zag" => "zag"}, {"muh_meh" => "meh"}], AdyenClient::Utils.massage_response(data)["object_list"]
    end

    it "should keep nested objects with single values" do
      assert_equal({"stays_nested" => 123}, AdyenClient::Utils.massage_response(data)["single_value"])
    end
  end

  describe "::snake_caseify" do
    it "should convert all kinds of camelCased, Class::Ified strings to snake_case, class/ified" do
      assert_equal "foo_bar", AdyenClient::Utils.snake_caseify("fooBar")
      assert_equal "foo_bar", AdyenClient::Utils.snake_caseify("FooBar")
      assert_equal "foo_bar", AdyenClient::Utils.snake_caseify("foo-bar")
      assert_equal "foo123_bar", AdyenClient::Utils.snake_caseify("foo123Bar")
      assert_equal "foo/bar", AdyenClient::Utils.snake_caseify("Foo::Bar")
    end
  end
end

