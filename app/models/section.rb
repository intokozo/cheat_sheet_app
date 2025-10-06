class Section < ApplicationRecord
  belongs_to :parent, class_name: "Section", optional: true
  has_many :children, class_name: "Section", foreign_key: "parent_id", dependent: :destroy
  has_many :articles, dependent: :destroy

  validates :title, presence: true

  validate :cannot_be_own_parent

  scope :roots, -> { where(parent_id: nil) }

  def full_path
    if parent
      "#{parent.full_path} / #{title}"
    else
      title
    end
  end

  def depth
    parent ? parent.depth + 1 : 0
  end

  def descendants
    children.flat_map do |child|
      [ child ] + child.descendants
    end
  end

  private

  def cannot_be_own_parent
    errors.add(:parent_id, "не может быть самим собой") if parent_id.present? && id.present? && parent_id == id
  end
end
