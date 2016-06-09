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
    set :addr_verification, {:verify_strict => ['delivery','zip4']}
	end

	get '/' do
		redirect '/shipment'
	end

  get '/shipment' do
    erb :index
  end

	post '/shipment' do
		unless EasyPost.api_key || EasyPost.api_key != ""
      halt(401, erb(:index, locals: {:error_message => "Check your API Key"}))
		end

    if params[:verify] == "true"
      params[:address].merge!(settings.addr_verification)
    end

    begin	
			from_addr_id = "adr_XXXXXXXXXXXXXXXXXXXXXXXXXXX70604"
      from_address = EasyPost::Address.retrieve(from_addr_id)
		  to_address = EasyPost::Address.create(params[:address])

      shipment = EasyPost::Shipment.create(
        :from_address => from_address,
        :to_address => to_address,
        :parcel => params[:parcel]
      )

      redirect "shipment/#{shipment.id}"
    rescue EasyPost::Error => e
      erb :index, locals: {from_address: from_address,
                           to_address: to_address,
                           parcel: params[:parcel],
                           verify: "true",  exception: e}
    end
	end


  get '/shipment/:id' do
    shipment = EasyPost::Shipment.retrieve(params[:id])
    to_address = EasyPost::Address.retrieve(shipment.to_address.id)
    halt 404, 'Not found' unless shipment
    erb :rate, locals: { shipment: shipment }
  end

	post '/shipment/:id/label' do
    shipment = EasyPost::Shipment.retrieve(params[:id])
    halt 404, 'Not found' unless shipment
    begin
      shipment.buy(:rate => {id: params[:rate]})
      raise "Failed to buy label" unless shipment.postage_label
      redirect "shipment/#{shipment.id}/label"
    rescue e
      halt 400, erb(:rate, locals: { error_message: e.message }) 
    end  
	end

	get '/shipment/:id/label' do
		shipment = EasyPost::Shipment.retrieve(params["id"])
    halt 404, 'Not found' unless shipment
    erb :label, locals: { shipment: shipment }
	end

	run! if app_file == $0
end