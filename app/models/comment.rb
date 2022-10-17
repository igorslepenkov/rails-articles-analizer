class Comment < ApplicationRecord
  validates :text, presence: true
  belongs_to :article, dependent: :destroy
end
