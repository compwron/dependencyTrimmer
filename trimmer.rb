# find all .gradle files 
def procdir(dir)
  Dir[File.join(dir, '**', '*')].reject { |p|
    File.directory? p
  }.reject { |p| !p.include?(".gradle") }
end

# assuming that this is being run from current directory
gradles = procdir(".")

dependencies = gradles.map { |filepath|
  file = File.open(filepath, "rb")
  contents = file.read.split("\n")
  contents.reject { |line|
    !line.include?("ompile")
  }
}

def clean_dependencies(dependencies)
#  Return just the bit between the quotes
  dependencies
end

clean = clean_dependencies(dependencies)

duplicates = clean.select{|dep| clean.count(dep) > 1}.uniq

p "Possible duplicate dependencies: #{duplicates}"

# Possible problem: using gsub will remove all of one dependencies - so duplicates will go undetected.


# find everything in dependcy{} (to start with)

# remove one dependency at a time, run tests from commandline
# (alternative: understand the packages in the dependency and check import statements, 
# but what about transitive dependencies?)

# if tests pass, leave it out

# print a report