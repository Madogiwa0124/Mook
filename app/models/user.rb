class User < ApplicationRecord
  has_many :favorite
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
