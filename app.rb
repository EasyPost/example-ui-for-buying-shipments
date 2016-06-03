require 'sinatra/base'
require 'sinatra/flash'
require 'easypost'
require 'tilt/erb'
require 'dotenv'
require 'pry'

require './lib/helpers'


class App < Sinatra::Base
	set :after_handler, :show_exceptions
	enable :sessions
    register Sinatra::Flash
    helpers Helpers

	Dotenv.load
	
	configure do 
		EasyPost.api_key = ENV['EASYPOST_API_KEY']
	end

	get '/' do
		erb :index
	end

	post '/shipment' do
		@success = []
		@errors = []
		if EasyPost.api_key=="" || EasyPost.api_key==nil
			status 401
			erb :_errors, locals: {:error_message => "Check your API Key"}					
		else
	        verify = {:verify => ['delivery','zip4']}

	        if params["pre-verify"] == "true"
	        	params[:address][0].merge!(verify)
	        	params[:address][1].merge!(verify)

	        	from_address = EasyPost::Address.create(params[:address][0])
		        to_address = EasyPost::Address.create(params[:address][1])

		        if from_address && to_address
		        	verification(from_address[:verifications], @success, @errors )
		        	verification(to_address[:verifications], @success, @errors)
		        	print_message
		        end
		     end

	        parcel = {
	        	:width => params["width"],
	            :length => params["length"],
	            :height => params["height"],
	            :weight => params["weight"],
	            :predefined_package => params["predefined"]
	        }

	        shipment = EasyPost::Shipment.create(
		     :to_address => params[:address][0],
		     :from_address => params[:address][1],
		     :parcel => parcel
			)

			@shipment = shipment.rates

		    if shipment.rates.count == 0
				status 400 
				erb :rate, locals: {
					:error_message => "Oops! Shipping object could not be created. Please try again."
				}
		 	else	
	        	erb :rate
	    	end
		end
	end

	post '/shipment/:id/rate' do
		if params["id"]
			shipment = EasyPost::Shipment.retrieve(params["id"])
			@shipment_label = shipment.buy(:rate => {id: params["rate"]})
			if @shipment_label==""
				status 400
				erb :rate, locals: {
						error_message: "Oops! Shipment label creation not successful. Please try again."
					}
			else
				erb :label	
			end
		else
			flash[:error] = "Could not retrieve shipment."
		end
	end
end