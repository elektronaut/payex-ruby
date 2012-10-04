[![Build Status](https://travis-ci.org/gointeractive/payex-ruby.png)](https://travis-ci.org/gointeractive/payex-ruby)

```ruby
require 'payex'

# This is how a basic PayEx transaction works:

PayEx.account_number = 123456789
PayEx.encryption_key = 'e4939be3910ebu194'

PayEx.return_url = 'http://example.com/payex-return'
PayEx.cancel_url = 'http://example.com/payex-cancel'

local_order_id = 'c704acc45a4bec4c8cd50b73fb01a7c7'

payment_url = PayEx.authorize_transaction! local_order_id,
  product_number: '123456',
  product_description: 'Brief product description',
  price: 14900, # Price in cents
  customer_ip: '12.34.56.78'

# After sending the customer to `payment_url`, they will enter their
# payment details before being redirected back to `PayEx.return_url`
# with an `orderRef` parameter appended to the query string:
#
#   <http://example.com/payex-return?orderRef=9b4031c19960da92d>
#
# By giving the `orderRef` value to `PayEx.complete_transaction!` you
# retreive your local order ID and your app can proceed from there.

begin
  local_order_id = PayEx.complete_transaction! '9b4031c19960da92d'
  # [transaction successful]
rescue PayEx::Error => error
  # [transaction unsucessful]
end
```
