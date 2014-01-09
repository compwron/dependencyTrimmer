# find all .gradle files 
def procdir(dir)
  Dir[File.join(dir, '**', '*')].reject { |p|
    File.directory? p
  }.reject { |p| !p.include?(".gradle") }
end

# assuming that this is being run from current directory
gradles = procdir(ARGV[0] || ".")

puts "Detected gradle files: \n#{gradles.join("\n")}\n"
dependencies = gradles.map { |filepath|
  file = File.open(filepath, "rb")
  content_lines = file.read.split("\n")
  content_lines.select { |line|
    line.include?("ompile")
  }.map { |line|
    line.scan(/\.*'(.*)\'/)
  }
}.flatten

puts "deps: #{dependencies}"


def clean_dependencies(dependencies)
#  Return just the bit between the quotes
  dependencies.map { |dep|
    dep.scan(/\.*'(.*)\'/)
  }.flatten
end

clean = clean_dependencies(dependencies)

puts "Detected dependencies: \n#{clean.join("\n")}\n\n"

duplicates = clean.select { |dep| clean.count(dep) > 1 }.uniq

puts "Possible duplicate dependencies: \n#{duplicates.join("\n")}" # maybe add file that they are found in to this?

# Possible problem: using gsub will remove all of one dependencies - so duplicates will go undetected.


# find everything in dependcy{} (to start with)

# remove one dependency at a time, run tests from commandline
# (alternative: understand the packages in the dependency and check import statements, 
# but what about transitive dependencies?)

# if tests pass, leave it out

# print a report