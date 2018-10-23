class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create_commit :add_customer_id


  def add_customer_id
    if  self.customer_id.nil?
    customer = Stripe::Customer.create(
              :email => self.email
            )

    self.customer_id = customer.id
    self.save
  end
end
end
