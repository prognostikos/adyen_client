class AdyenClient

  class Response
    attr_reader :code

    def initialize(http_response)
      @code = http_response.code
      @data = Utils.massage_response(http_response.parsed_response)
    end

    def success?
      code == 200
    end

    def authorised?
      success? && result_code == "Authorised"
    end
    alias_method :authorized?, :authorised? # for our friends abroad

    def to_hash
      @data
    end

    def respond_to_missing?(name)
      @data.has_key?(name.to_s)
    end

    def method_missing(name)
      @data.fetch(name.to_s) { super }
    end
  end

end

