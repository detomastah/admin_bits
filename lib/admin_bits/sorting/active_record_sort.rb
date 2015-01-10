module AdminBits::ActiveRecordSort
  def by_each_attribute
    attribute_names = resource.attribute_names

    attribute_names.each do |attribute|
      method_name = "by_#{attribute}"
      self.class.send :define_method, method_name do |resource, direction = :asc|
        resource.order("#{attribute} #{direction}")
      end
    end

    attribute_names.map { |a| "by_#{a}".to_sym }
  end
end
