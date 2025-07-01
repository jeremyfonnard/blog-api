# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: self

         has_many :articles, dependent: :destroy
         has_many :comments, dependent: :destroy
         has_many :photos, dependent: :destroy

         validates :email, presence: true

  def self.jwt_revocation_strategy
    JwtDenylist
  end
end