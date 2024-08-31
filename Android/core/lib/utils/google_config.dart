const String googlePayConfiguration = '''
{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "parameters": {
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "allowedCardNetworks": ["AMEX", "DISCOVER", "JCB", "MASTERCARD", "VISA"]
        },
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example", 
            "gatewayMerchantId": "exampleMerchantId"
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "exampleMerchantId",
      "merchantName": "Example Merchant"
    },
    "transactionInfo": {
      "totalPriceStatus": "FINAL",
      "totalPriceLabel": "Total",
      "currencyCode": "USD",
      "countryCode": "US"
    }
  }
}
''';