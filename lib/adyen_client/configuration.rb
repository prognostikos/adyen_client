class AdyenClient::Configuration
  BASE_URI = "https://pal-%s.adyen.com/pal/servlet"

  attr_accessor :environment
  attr_accessor :username
  attr_accessor :password
  attr_accessor :cse_public_key
  attr_accessor :default_merchant_account
  attr_accessor :default_currency
  attr_accessor :api_version

  def set(hash)
    hash.each { |k, v| send("#{k}=", v) if respond_to?("#{k}=") }
  end

  def apply(klass)
    klass.base_uri(BASE_URI % environment)
    klass.basic_auth(username, password)
    # prevent following redirects and raise HTTParty::RedirectionTooDeep
    klass.no_follow(true)
    klass.format(:json)
    klass.headers("Content-Type" => "application/json; charset=utf-8")
  end
end

