module PayEx::PxOrder
  extend self

  def wsdl
    '%s/pxorder/pxorder.asmx?WSDL' % PayEx.base_url
  end

  def Initialize7(params)
    PayEx::API.invoke! wsdl, 'Initialize7', params, {
      'accountNumber' => {
        :signed => true,
        :default => proc { PayEx.account_number! }
      },
      'purchaseOperation' => {
        :signed => true
      },
      'price' => {
        :signed => true,
        :format => Integer
      },
      'priceArgList' => {
        :signed => true,
        :default => ''
      },
      'currency' => {
        :signed => true,
        :default => proc { PayEx.default_currency! }
      },
      'vat' => {
        :signed => true,
        :format => Integer,
        :default => 0
      },
      'orderID' => {
        :signed => true,
        :format => /^[a-z0-9]{1,50}$/i
      },
      'productNumber' => {
        :signed => true,
        :format => /^[A-Z0-9]{1,50}$/
      },
      'description' => {
        :signed => true,
        :format => /^.{1,160}$/
      },
      'clientIPAddress' => {
        :signed => true
      },
      'clientIdentifier' => {
        :signed => true,
        :default => ''
      },
      'additionalValues' => {
        :signed => true,
        :default => ''
      },
      'externalID' => {
        :signed => true,
        :default => ''
      },
      'returnUrl' => {
        :signed => true
      },
      'view' => {
        :signed => true,
        :default => 'CREDITCARD'
      },
      'agreementRef' => {
        :signed => true,
        :default => ''
      },
      'cancelUrl' => {
        :signed => true,
        :default => ''
      },
      'clientLanguage' => {
        :signed => true,
        :default => ''
      }
    }, %w{
      accountNumber purchaseOperation price priceArgList currency
      vat orderID productNumber description clientIPAddress clientIdentifier
      additionalValues externalID returnUrl view agreementRef cancelUrl
      clientLanguage
    }
  end

  def Complete(params)
    PayEx::API.invoke! wsdl, 'Complete', params, {
      'accountNumber' => {
        :signed => true,
        :default => proc { PayEx.account_number! }
      },
      'orderRef' => {
        :signed => true
      }
    }, %w{accountNumber orderRef}
  end
end
