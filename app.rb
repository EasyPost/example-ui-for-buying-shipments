require 'sinatra/base'
require 'sinatra/flash'
require 'easypost'
require 'tilt/erb'
require 'dotenv'
require 'pry'
require './lib/helpers'

class App < Sinatra::Base
  set :show_exceptions, false
  enable :sessions
  register Sinatra::Flash
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
    unless EasyPost.api_key || EasyPost.api_key != ""
      halt(401, erb(:index, locals: {error_message: "Check your API Key"}))
    end
    # part of address object not address attribute of shipment.
    if params[:verify] == "true"
      params[:address].merge!(settings.addr_verification)
    end
    begin
      from_addr_id = ENV['FROM_ADDRESS_ID']
      to_address = EasyPost::Address.create(params[:address])
      shipment = EasyPost::Shipment.create(
        from_address: {id: from_addr_id},
        to_address: {id: to_address[:id]},
        parcel: params[:parcel]
      )
      redirect "shipment/#{shipment.id}/rates"
    rescue EasyPost::Error => e
      erb :index, locals: {
        from_address: {id: from_addr_id},
        to_address: to_address,
        parcel: params[:parcel],
        verify: "true",
        exception: e
      }
    end
  end

  get '/shipment/:id/rates' do
    shipment = EasyPost::Shipment.retrieve(params[:id])
    halt 404, 'Not found' unless shipment
    erb :rate, locals: {shipment: shipment}
  end

  post '/shipment/:id/buy' do
    shipment = EasyPost::Shipment.retrieve(params[:id])
    halt 404, 'Not found' unless shipment
    begin
      shipment.buy(rate: {id: params[:rate]})
      raise "Failed to buy label" unless shipment.postage_label
      redirect "shipment/#{shipment.id}"
    rescue e
      halt 400, erb(:rate, locals: {error_message: e.message})
    end
  end

  get '/shipment/:id' do
    shipment = EasyPost::Shipment.retrieve(params[:id])
    halt 404, 'Not found' unless shipment
    erb :shipment, locals: {shipment: shipment}
  end
  run! if app_file == $0
end