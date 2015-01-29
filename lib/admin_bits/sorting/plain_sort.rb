module AdminBits::PlainSort
  def plain(resource, direction = :asc)
    direction = direction.downcase.to_sym
    resource.sort!
    resource.reverse! if direction == :desc
    resource
  end
end
