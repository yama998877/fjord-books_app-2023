# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :postal_code, length: { is: 7 }, on: :update, allow_blank: true,
                          format: { with: /\A[0-9]+\z/ }
end
