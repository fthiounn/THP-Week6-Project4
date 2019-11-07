class ChargesController < ApplicationController
  def new
    @event = Event.find(params[:event_id])
    @amount = @event.price
  end

  def create
    @event = Event.find(params[:event_id])
    @token = params[:stripeToken]

    redirect_to new_attendance_path(event: @event,token: @token)
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
