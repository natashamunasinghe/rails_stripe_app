class PagesController < ApplicationController
   before_action :authenticate_user!
    
    def home
        @user = current_user
    end

        def process_payment
            # Amount in cents
            @amount = 500
          
            # customer = Stripe::Customer.create(
            #   :email => params[:stripeEmail],
            #   :source  => params[:stripeToken]
            # )

            customer = Stripe::Customer.retrieve(current_user.customer_id)
            customer.source = params[:stripeToken]
            customer.save
          
            charge = Stripe::Charge.create(
              :customer   => current_user.customer_id,
              :amount      => @amount,
              :description => 'Rails Stripe customer',
              :currency    => 'aud'
            )
          
            redirect to "/"

          rescue Stripe::CardError => e
            flash[:error] = e.message
            redirect_to new_charge_path
          end
end
