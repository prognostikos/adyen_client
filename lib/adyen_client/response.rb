class AdyenClient::Response
  def self.parse(http_response)
    new(http_response.code, AdyenClient::Utils.massage_response(http_response.parsed_response))
  end

  attr_reader :code, :data
  alias_method :to_hash, :data

  def initialize(code, data)
    @code, @data = code, data
  end

  def success?
    code == 200
  end

  def authorised?
    success? && result_code == "Authorised"
  end
  alias_method :authorized?, :authorised? # for our friends abroad

  def respond_to_missing?(name, include_private = false)
    @data.has_key?(name.to_s) || super
  end

  def method_missing(name, *args, &block)
    @data.fetch(name.to_s) { super(name, *args, &block) }
  end
end

