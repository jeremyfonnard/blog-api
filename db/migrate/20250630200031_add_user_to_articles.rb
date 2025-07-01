# db/migrate/20250630200031_add_user_to_articles.rb

class AddUserToArticles < ActiveRecord::Migration[7.0]
  def change
    # Retire null: false pour permettre à la migration de passer sur des données existantes
    add_reference :articles, :user, foreign_key: true
  end
end