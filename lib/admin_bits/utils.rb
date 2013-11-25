module AdminBits
  class Utils
    def self.split_text(text)
      text.strip.split(/\s+/)
    end

    # Returns array of confitions for text search
    def self.create_search_conditions(text, columns)
      text = split_text(text).join("%")
      text = "%" + text + "%"
      conditions = [columns.map {|c| "#{c} LIKE ?"}.join(" OR ")]
      columns.length.times { conditions << text }
      conditions
    end
  end
end
