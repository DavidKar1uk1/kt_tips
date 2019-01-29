require 'sinatra'
require 'yaml/store'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require './config/environments'
require 'k2_connect_ruby'
require './app/models/kt_tip'

# The Paths
# Homepage
get '/' do
  @title = 'Welcome to KT Tips'
  erb :index
end

# The Crud Ops
# The Tech Tips (show)
get '/kt_tips' do
  @kt_tips = KtTip.all
  erb :kt_tips_show
end

# A Tech Tip (show one)
get '/kt_tips/:id' do
  # @kt_tip = KtTip.find(params[:id])
  erb :kt_tip
end

# Create a Tech Tip (create)
post '/kt_tips_create' do
  @kt_tip = KtTip.create(params[:kt_tip])
  if @kt_tip.save
    redirect '/kt_tips'
  else
    "Error!"
  end
  erb :create_kt_tip
end

# Delete a Tech Tip (delete)
delete '/kt_tips/:id' do
  KtTip.destroy(params[:id])
end

# The Choice Made (show choice)
post '/tech' do
  @title = 'Thanks for your Input'
  @intel= params['intel']
  @store = YAML::Store.new 'config/intel.yml'
  @store.transaction do
    @store['intel'] ||= {}
    @store['intel'][@intel] ||= 0
    @store['intel'][@intel] += 1
  end
  erb :tech
end

# The Results (show)
get '/results' do
  @title = 'Results so Far:'
  @store = YAML::Store.new 'config/intel.yml'
  @intel = @store.transaction { @store['intel'] }
  erb :results
end

# For receive the K2 JSON Response
post '/parse' do
  k2_test = K2ConnectRuby::K2Client.new(ENV["K2_SECRET_KEY"])
  k2_test.parse_request(request)
  k2_truth_value = K2ConnectRuby::K2Authorize.new.authenticate(k2_test.hash_body, k2_test.api_secret_key, k2_test.k2_signature)
  k2_components = K2ConnectRuby::K2SplitRequest.new(k2_truth_value)
  k2_components.judge_truth(k2_test.hash_body)
end

# For collecting the K2 Webhook
post '/subscription' do

end

# The Array of choices
Choices = {
    'i9' => 'Core i9 9900k',
    'i7' => 'Core i7 9700k',
    'i5' => 'Core i5 9600k',
    'i3' => 'Core i3 9100',
}