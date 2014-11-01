class Item < ActiveRecord::Base

  def self.having_name(name)
    name = "%#{name}%"
    where(["name LIKE ?", name])
  end
end
