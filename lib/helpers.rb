module Helpers
  def render_addr_verification_messages(address)
    errors = address[:error][:errors].map { |error| error[:message] }
    erb :_verification_message, locals: {errors: errors}
  end
end
