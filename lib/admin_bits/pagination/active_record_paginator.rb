module ActiveRecordPaginator
  def paginate(resource, page)
    resource.page(page).per(self.class.per_page_amount)
  end
end
