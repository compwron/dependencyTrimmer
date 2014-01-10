require_relative 'lib/gradle_files'
require_relative 'lib/dependencies'

gradles = GradleFiles.new(ARGV[0] || ".")
puts "Detected gradle files: \n#{gradles.pretty}\n\n"

dependencies = Dependencies.new(gradles.files)
puts "Detected #{dependencies.count} dependencies:\n#{dependencies.pretty}\n"
puts "\nPossible duplicate dependencies: \n#{dependencies.duplicates}"

# given list of dependencies saved to file (as yml?), delete the first one from gradle file (once) and run command?
require 'yaml' # Built in, no gem required


# put all deps in yml
# git commit
# remove first instance
# # run tests
# if tests fail, reset to git commit and put dep name in required.yml
# if tests pass, put dep name in not_required.yml and remove next dep


all_dependencies_yml = 'config/dependencies.yml'
all_dependencies = YAML::load_file(all_dependencies_yml) #Load
all_dependencies['dependency_record'] = dependencies.dependencies
File.open(all_dependencies_yml, 'w') {|f| f.write all_dependencies.to_yaml } #Store

puts "I wrote: #{YAML::load_file(all_dependencies_yml) }"

def remove_from_first_instance_in_gradle_files files, dependency_name
  files.files.each {|file|
    contents = File.open(file, "rb").read
    if(contents).include?(dependency_name) then
      File.open(file, "w") {|file| file.puts contents.gsub(dependency_name, "")}
      return true
    end
  }
  return false
end





def run_tests test_command, dependency_name
  puts "running tests with command: #{test_command}"
  did_it_work = !`#{test_command}`.include?("FAILED")

  # remove 
  puts "did it work? #{did_it_work} -------"
  did_it_work
end

# did_it_work = true

# dependencies.dependencies.each {|dep|
#   did_it_work = remove_from_first_instance_in_gradle_files(gradles, dep)
#   if (!did_it_work) then 
#     return  
#   end
#   run_tests(ARGV[1] || "gradle clean test", dep)
# }