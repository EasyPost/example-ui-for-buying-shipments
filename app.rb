require 'sinatra/base'
require 'easypost'
require 'tilt/erb'
require 'dotenv'
require 'pry'
require './lib/helpers'

class App < Sinatra::Base
  set :show_exceptions, :after_handler
  enable :sessions
  helpers Helpers

  configure :development, :test do
    Dotenv.load
  end

  configure do
    EasyPost.api_key = ENV['EASYPOST_API_KEY']
    set :addr_verification, {verify_strict: ['delivery','zip4']}
  end

  get '/' do
    redirect '/shipment'
  end

  get '/shipment' do
    erb :index
  end

  post '/shipment' do
    begin
      from_address = EasyPost::Address.retrieve(ENV['FROM_ADDRESS_ID'])
      to_address = if params[:verify] == "true"
                     EasyPost::Address.create(params[:address].merge(settings.addr_verification))
                   else
                     params[:address]
                   end
      shipment = EasyPost::Shipment.create(
        from_address: from_address,
        to_address: to_address,
        parcel: params[:parcel]
      )
      redirect "shipment/#{shipment.id}/rates"
    rescue EasyPost::Error => e
      erb :index, locals: {
        from_address: from_address,
        to_address: to_address,
        parcel: params[:parcel],
        verify: params[:verify],
        exception: e
      }
    end
  end

  get '/shipment/:id/rates' do
    erb :rate, locals: {shipment: retrieve_shipment}
  end

  post '/shipment/:id/buy' do
    shipment = retrieve_shipment
    begin
      shipment.buy(rate: {id: params[:rate]})
      raise "Failed to buy label" unless shipment.postage_label
      redirect "shipment/#{shipment.id}"
    rescue EasyPost::Error => e
      halt 400, erb(:rate, locals: {exception: e})
    end
  end

  get '/shipment/:id' do
    erb :shipment, locals: {shipment: retrieve_shipment}
  end

  run! if app_file == $0
end