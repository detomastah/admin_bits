module PlainSort
  def plain(resource, direction = :asc)
    resource.sort!
    resource.reverse! if direction == 'DESC'
    resource
  end
end
