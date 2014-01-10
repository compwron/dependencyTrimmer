class Dependencies
  attr_reader :dependencies

  def initialize files
    @dependencies = files.map { |file|
      get_dependencies(File.open(file, "rb").read)
    }.flatten
  end

  def get_dependencies file_text
    file_text.split("\n").map { |dep|
      dep.scan(/["|'](.*:.*):.*["|']/)
    }.flatten
  end

  def count
    @dependencies.count
  end

  def pretty
    @dependencies.join("\n")
  end

  def duplicates
    duplicate_counts().reject { |dup_name, dup_count|
      dup_count == 1
    }.map { |dup_name, dup_count|
      "found #{dup_count} times: #{dup_name}"
    }.join("\n")
  end

  def duplicate_counts
    dup_hash = {}
    @dependencies.each { |dep|
      if (dup_hash[dep] == nil) then
        dup_hash.merge!({dep => 1})
      else
        dup_hash[dep] += 1
      end
    }
    dup_hash
  end
end