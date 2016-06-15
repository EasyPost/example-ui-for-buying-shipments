module Helpers
  def render_addr_verification_messages(address)
    errors = address[:error][:errors].map { |error| error[:message] }
    erb :_verification_message, locals: {errors: errors}
  end

  def retrieve_shipment
    shipment = EasyPost::Shipment.retrieve(params[:id])
    halt 404, 'Not found' unless shipment
    shipment
  end
end