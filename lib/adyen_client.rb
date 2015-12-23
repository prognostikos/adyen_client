require "httparty"
require "adyen_client/utils"
require "adyen_client/response"
require "adyen_client/configuration"

class AdyenClient
  include HTTParty

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure(hash = nil)
    configuration.set(hash) if hash
    yield configuration if block_given?
    configuration.apply(self)
  end

  def self.generation_time
    Time.now.iso8601
  end

  def self.cse_public_key
    configuration.cse_public_key
  end

  attr_reader :merchant_account

  def initialize(merchant_account: configuration.default_merchant_account, response_class: Response)
    @merchant_account = merchant_account
    @response_class = response_class
  end

  def authorise_recurring_payment(amount:, reference:, recurring_reference: "LATEST", shopper:, merchant_account: @merchant_account, currency: configuration.default_currency)
    postJSON("/Payment/v12/authorise",
      reference: reference,
      amount: { value: amount, currency: currency },
      merchantAccount: merchant_account,
      shopperReference: shopper[:reference],
      selectedRecurringDetailReference: recurring_reference,
      selectedBrand: "",
      recurring: { contract: "RECURRING" },
      shopperInteraction: "ContAuth"
    )
  end
  alias_method :authorize_recurring_payment, :authorise_recurring_payment

  def list_recurring_details(shopper_reference:, merchant_account: @merchant_account, contract: "RECURRING")
    postJSON("/Recurring/v12/listRecurringDetails",
      shopperReference: shopper_reference,
      recurring: { contract: contract },
      merchantAccount: merchant_account
    )
  end

  def create_recurring_contract(encrypted_card:, reference:, merchant_account: @merchant_account, currency: configuration.default_currency, shopper: {})
    postJSON("/Payment/v12/authorise",
      reference: reference,
      additionalData: { "card.encrypted.json": encrypted_card },
      amount: { value: 0, currency: currency },
      merchantAccount: merchant_account,
      shopperEmail: shopper[:email],
      shopperIP: shopper[:ip],
      shopperReference: shopper[:reference],
      recurring: { contract: "RECURRING" }
    )
  end

  def authorise(amount:, encrypted_card:, reference:, merchant_account: @merchant_account, currency: configuration.default_currency, shopper: {})
    postJSON("/Payment/v12/authorise",
      reference: reference,
      amount: { value: amount, currency: currency },
      merchantAccount: merchant_account,
      additionalData: { "card.encrypted.json": encrypted_card }
    )
  end
  alias_method :authorize, :authorise

  def verify(amount:, encrypted_card:, reference:, merchant_account: @merchant_account, currency: configuration.default_currency, shopper: {})
    postJSON("/Payment/v12/authorise",
      reference: reference,
      amount: { value: 0, currency: currency },
      additionalAmount: { value: amount, currency: currency },
      merchantAccount: merchant_account,
      additionalData: { "card.encrypted.json": encrypted_card }
    )
  end

  def capture(original_reference:, amount:, reference:, merchant_account: @merchant_account, currency: configuration.default_currency)
    postJSON("/Payment/v12/capture",
      reference: reference,
      merchantAccount: merchant_account,
      modificationAmount: { value: amount, currency: currency },
      originalReference: original_reference
    )
  end

  def cancel(original_reference:, reference:, merchantAccount: @merchant_account)
    postJSON("/Payment/v12/cancel",
      reference: reference,
      merchantAccount: merchant_account,
      originalReference: original_reference
    )
  end

  def refund(original_reference:, amount:, reference:, merchantAccount: @merchant_account, currency: configuration.default_currency)
    postJSON("/Payment/v12/refund",
      reference: reference,
      merchantAccount: merchant_account,
      modificationAmount: { value: amount, currency: currency },
      originalReference: original_reference
    )
  end

  def cancel_or_refund(original_reference:, reference:, merchantAccount: @merchant_account)
    postJSON("/Payment/v12/cancelOrRefund",
      reference: reference,
      merchantAccount: merchant_account,
      originalReference: original_reference
    )
  end

  def postJSON(path, data)
    response = self.class.post(path, body: data.to_json)
    @response_class ? @response_class.parse(response) : response
  end

  def configuration
    self.class.configuration
  end

end

