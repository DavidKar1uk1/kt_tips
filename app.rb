require 'sinatra'
require 'sinatra/base'
require 'k2-connect-ruby'
# require 'yaml/store'
# require 'sinatra/config_file'
# require 'sinatra/reloader'
require 'sinatra/activerecord'
require './config/environments'
require './app/models/kt_tip'
require './app/controllers/kt_testing_controller'
require './app/controllers/processing_controller'

class KtTipSinatra < Sinatra::Base
  use KtTestingController
  use ProcessingController
# Homepage
  get '/' do
    @title = 'Welcome to KT Tips'
    @options = { i9: 'Core i9 9900k', i7: 'Core i7 9700k', i5: 'Core i5 9600k', i3: 'Core i3 9100' }
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

# The Option Made (show option)
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

end