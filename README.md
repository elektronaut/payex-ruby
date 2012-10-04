[![Build Status](https://travis-ci.org/gointeractive/payex-ruby.png)](https://travis-ci.org/gointeractive/payex-ruby)

```ruby
require 'payex'

# The following example illustrates how a basic PayEx credit card
# redirect transaction works.  This is the only type of transaction
# currently supported by this library.

# These must always be set first:
PayEx.account_number = 123456789
PayEx.encryption_key = 'e4939be3910ebu194'

# Set once or provide every time:
PayEx.default_currency = 'SEK'

local_order_id = 'c704acc45a4bec4c8cd50b73fb01a7c7'

payment_href = PayEx::CreditCardRedirect.initialize_transaction! \
  order_id: local_order_id,
  product_number: '123456',
  product_description: 'Brief product description',
  price: 14900, # Price in cents
  customer_ip: '12.34.56.78',
  return_url: 'http://example.com/payex-callback',
  cancel_url: 'http://example.com/products/123456'

# After sending the customer to `payment_href`, they will enter their
# payment details before being redirected back to `PayEx.return_url`
# with an `orderRef` parameter appended to the query string:
#
#    http://example.com/payex-callback?orderRef=9b4031c19960da92d
#
# By giving the `orderRef` value to `#complete_transaction!` you
# retreive your local order ID and your app can proceed from there.

local_order_id, error, transaction_data =
  PayEx::CreditCardRedirect.complete_transaction! '9b4031c19960da92d'

case error
when nil
  # Transaction successful
when PayEx::Error::CardDeclined
  # Card declined
else
  # Transaction failed for another reason
end
```
