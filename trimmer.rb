def procdir(dir)
  Dir[File.join(dir, '**', '*')].reject { |p|
    File.directory? p
  }.reject { |p|
    !p.include?(".gradle")
  }.reject {|p|
    p.include?("/out/")
  }
end

def clean_dependencies(dependencies)
  dependencies.map { |dep|
    dep.scan(/["|'](.*:.*):.*["|']/)
  }.flatten
end

def pretty_duplicates(dup_hash)
  dup_hash.select { |dup_name, dup_count|
    dup_count != 1
  }.map { |dup_name, dup_count|
    "found #{dup_count} times: #{dup_name}"
  }.join("\n")
end

gradles = procdir(ARGV[0] || ".")

puts "Detected gradle files: \n#{gradles.join("\n")}\n\n"
dependencies = gradles.map { |filepath|
  file = File.open(filepath, "rb")
  content_lines = file.read.split("\n")
  clean_dependencies(content_lines)
}.flatten

puts "Detected #{dependencies.count} dependencies:
     \n#{dependencies.join("\n")}\n"

duplicates = {}

dependencies.each { |dep|
  if (duplicates[dep] == nil) then
    duplicates.merge!({dep => 1})
  else
    duplicates[dep] += 1
  end
}

puts "\nPossible duplicate dependencies: \n#{pretty_duplicates(duplicates)}"