# find all .gradle files 
def procdir(dir)
  Dir[ File.join(dir, '**', '*') ].reject { |p| 
  	File.directory? p 
  }.reject {|p| !p.include?(".gradle")}
end

# assuming that this is being run from current directory
gradles = procdir(".")

dependencies = gradles.map { |filepath|

}
# find everything in dependcy{} (to start with)

# remove one dependency at a time, run tests from commandline
# (alternative: understand the packages in the dependency and check import statements, 
	# but what about transitive dependencies?)

# if tests pass, leave it out

# print a report