class Dependencies
  attr_accessor :dependencies

  def initialize files
    @dependencies = files.map { |file|
      get_dependencies(file)
    }.flatten
  end

  def get_dependencies file
    File.open(file, "rb").read.split("\n").map { |dep|
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

    dup_hash = {}
    @dependencies.each { |dep|
      if (dup_hash[dep] == nil) then
        dup_hash.merge!({dep => 1})
      else
        dup_hash[dep] += 1
      end
    }

    dup_hash.select { |dup_name, dup_count|
      dup_count != 1
    }.map { |dup_name, dup_count|
      "found #{dup_count} times: #{dup_name}"
    }.join("\n")
  end
end