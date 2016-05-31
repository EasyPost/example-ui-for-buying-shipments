require 'sinatra/base'
require 'easypost'
require 'tilt/erb'
require 'dotenv'


class App < Sinatra::Base
	Dotenv.load
	
	configure do 
		EasyPost.api_key = ENV['EASYPOST_API_KEY']
	end

	get '/' do
		erb :index
	end

	post '/shipment' do

        parcel = {
        	:width => params["width"],
            :length => params["length"],
            :height => params["height"],
            :weight => params["weight"],
            :predefined_package => params["predefined"]
        }

        shipment = EasyPost::Shipment.create(
	     :to_address => params["shipping"][0],
	     :from_address => params["shipping"][1],
	     :parcel => parcel
		)

		redirect "/" if shipment.rates.count == 0

        redirect "/shipment/#{shipment.id}"   
	end

	get '/shipment/:id' do
		retrieved_shipment = EasyPost::Shipment.retrieve(params["id"])
		@shipment = retrieved_shipment.rates
		erb :address
	end

	post '/shipment/:id/rate' do
		shipment = EasyPost::Shipment.retrieve(params["id"])
		@shipment_label = shipment.buy(:rate => {id: params["rate"]})
		erb :label	
	end
end