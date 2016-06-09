module Helpers
  def render_addr_verification_messages(address)
    errors =[]
    address[:error][:errors].map do |error|
      errors << (error[:message])
    end
    erb :_verification_message, locals: {errors: errors}
  end
end
