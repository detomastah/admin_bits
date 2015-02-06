module AdminBits
  class Extentions
    include AdminBitsLte if defined? AdminBitsLte
  end
end
