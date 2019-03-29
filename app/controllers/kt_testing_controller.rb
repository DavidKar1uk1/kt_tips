set :K2_SECRET_KEY, 'b647be91024bc03fb9e83f92238b973a4c070269'
set :ACCESS_TOKEN, ''

class KtTestingController < Sinatra::Base

  get '/test/subscription' do
    erb :subscription
  end

  get '/test/pay' do
    erb :pay
  end

  get '/test/transfers' do
    erb :transfers
  end

  get '/test/stk' do
    erb :stk
  end

# To receive the K2 JSON Response
  post '/parse' do
    k2_test = K2Client.new('b647be91024bc03fb9e83f92238b973a4c070269')
    k2_test.parse_request(request)
    K2Authenticator.authenticate(k2_test.hash_body, k2_test.api_secret_key, k2_test.k2_signature)

  end

# For K2 Webhook Subscription
  post '/subscription' do
    @k2_subscription = K2Subscribe.new(params[:subscription], ENV["K2_SECRET_KEY"])
    if @k2_subscription.token_request(ENV["CLIENT_ID"], ENV["CLIENT_SECRET"])
      settings.ACCESS_TOKEN = @k2_subscription.access_token
      @k2_subscription.webhook_subscribe
      @k1_test_token = K2Client.new(ENV["K2_SECRET_KEY"])
    end
  end

# POST /stk_push
  post 'stk_push' do
    @k2_stk = K2Stk.new(settings.ACCESS_TOKEN)
    case params[:decision]
    when "receive_stk"
      @k2_stk.receive_mpesa_payments(params)
    when "query_stk"
      @k2_stk.query_status(params)
    else
      puts "No Other STK Option"
    end
  end

# POST /pay
  post 'pay' do
    @k2_pay = K2Pay.new(settings.ACCESS_TOKEN)
    case params[:decision]
    when "pay_recipients_form"
      @k2_pay.pay_recipients(params)
    when "query_pay_form"
      @k2_pay.query_status(params)
    when "create_pay_form"
      @k2_pay.create_payment(params)
    else
      puts "No Other Pay Option."
    end
  end

# POST /transfers
  post 'transfers' do
    @k2_transfers = K2Transfer.new(settings.ACCESS_TOKEN)
    case params[:decision]
    when "verify_account_form"
      @k2_transfers.settlement_account(params)
    when "create_transfer_form"
      @k2_transfers.transfer_funds(params[:target], params)
    when "query_transfer_form"
      @k2_transfers.query_status(params)
    else
      puts "No Other Transfer Option."
    end
  end
end