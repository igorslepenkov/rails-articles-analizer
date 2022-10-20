class AddRatingToArticlesAndComments < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :rating, :integer

    add_column :articles, :impact, :string

    add_column :comments, :sentiment, :string

    add_column :comments, :confidence, :integer
  end
end
