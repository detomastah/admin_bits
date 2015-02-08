class Item < ActiveRecord::Base
  validates :name, presence: true

  def self.having_name(name)
    name = "%#{name}%"
    where(["name LIKE ?", name])
  end
end
