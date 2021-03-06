class Api::BraintreeController < ApplicationController
  
  def payment
    result = braintree::Transaction.sale(
      amount: params [:amount],
      payment_method_nonce: params[:nonce]
      options: {
        submit_for_settlement: true
      }
    )
    if result.success?
      render json: result.transaction.id
    elsif result.transaction
      text = "text: #{result.transaction.processor_response_text}"
      code = "code: #{result.transaction.processor_code}"
      render json: { errors: {test: text, code: code }}
    else
      render json: { errors: result.errors }
    end
  end

  def token
    render json: ENV['BRAINTREE_DROPIN_TOKEN']
  end
end
