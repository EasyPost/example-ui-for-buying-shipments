module Helpers
	def verification(hash, successarr, errorsarr)
		hash.each do |k, v|
			v.each do|k1,v1|
			   	if k1 == :success && v1 == true
			        successarr << v1
			    elsif k1 == :errors && v1.any?
			    	errorsarr << v1
				end
			end
		end
	end	

	def print_message
		if @errors.any?
			 @message = "There are some Error. Check your errors below"
		elsif @success.count == 4 
			@message = "Your Address has been successfully verified!"
		end
	end
end