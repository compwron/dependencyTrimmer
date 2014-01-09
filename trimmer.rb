# find all .gradle files 
def procdir(dir)
  Dir[File.join(dir, '**', '*')].reject { |p|
    File.directory? p
  }.reject { |p| !p.include?(".gradle") }
end

def fits_dependency_format line
  #puts line
  true
  matches = line.match(".*:.*:.*")
  puts "matches? #{matches}"
  matches
end

def clean_dependencies(dependencies)
#  Return just the bit between the quotes
  dependencies.map { |dep|
    dep.scan(/["|'](.*:.*):.*["|']/)
    # ".*:.*:.*"
  }.flatten
end

# assuming that this is being run from current directory
gradles = procdir(ARGV[0] || ".")

puts "Detected gradle files: \n#{gradles.join("\n")}\n\n"
dependencies = gradles.map { |filepath|
  file = File.open(filepath, "rb")
  content_lines = file.read.split("\n")
  clean_dependencies(content_lines)
}.flatten

puts "Detected dependencies:
  \ncount: #{dependencies.count}
  \n#{dependencies.join("\n")}\n"

duplicates = {}

dependencies.each { |dep|
  if (duplicates[dep] == nil) then
    duplicates.merge!({dep => 1})
  else
    duplicates[dep] += 1
  end
}

def pretty_duplicates(dup_hash)
  dup_hash.select{ |dup_name, dup_count| 
    dup_count != 1
    }.map{|dup_name, dup_count|
    "found #{dup_count} times: #{dup_name}"
  }.join("\n")
end

puts "\nPossible duplicate dependencies: \n#{pretty_duplicates(duplicates)}" # maybe add file that they are found in to this?

# Possible problem: using gsub will remove all of one dependencies - so duplicates will go undetected.


# find everything in dependcy{} (to start with)

# remove one dependency at a time, run tests from commandline
# (alternative: understand the packages in the dependency and check import statements, 
# but what about transitive dependencies?)

# if tests pass, leave it out

# print a report