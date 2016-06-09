module Helpers
	def render_addr_verification_messages(address)
		errors =[]
		address[:error][:errors].each do |error|
			errors << (error[:message])
		end
		erb :_verification_message, locals: {errors: errors}
	end
end
