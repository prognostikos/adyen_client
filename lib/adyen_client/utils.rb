module AdyenClient::Utils
  def massage_response(value, parent = nil)
    case value
    when Array
      value.map { |v| massage_response(v, value) }
    when Hash
      if parent.is_a?(Array) && value.count == 1
        _, v = value.first
        massage_response(v, value)
      else
        Hash[value.map { |k, v| [snake_caseify(k), massage_response(v, value)] }]
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

