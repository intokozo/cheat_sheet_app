class Article < ApplicationRecord
  belongs_to :section
  has_rich_text :content
end
