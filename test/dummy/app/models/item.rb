class Item < ActiveRecord::Base

  def self.having_name(name)
    name = "%#{name}%"
    where(["name LIKE ?", name])
  end

  def self.price_within(from, to)
    from = from.present? ? from.to_i : nil
    to   = to.present? ? to.to_i : nil

    ret = where(nil)
    ret = ret.where(["price <= ?", to]) if to
    ret = ret.where(["price >= ?", from]) if from
    ret
  end

end
