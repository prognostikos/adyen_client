class AdyenClient

  module Utils
    def massage_response(value)
      case value
      when Array
        value.map(&method(:massage_response))
      when Hash
        if value.count == 1
          _, v = value.first
          massage_response(v)
        else
          Hash[value.map { |k, v| [snake_caseify(k), massage_response(v)] }]
        end
      else
        value
      end
    end

    def snake_caseify(string)
      string
        .gsub("::", "/")
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr("-", "_")
        .downcase
    end

    extend self
  end

end

