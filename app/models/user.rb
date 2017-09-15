class User < ApplicationRecord
  has_many :favorite, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :pages
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
