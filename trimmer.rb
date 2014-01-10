require_relative 'lib/gradle_files'
require_relative 'lib/dependencies'

gradles = GradleFiles.new(ARGV[0] || ".")
puts "Detected gradle files: \n#{gradles.pretty}\n\n"

dependencies = Dependencies.new(gradles.files)
puts "Detected #{dependencies.count} dependencies:\n#{dependencies.pretty}\n"
puts "\nPossible duplicate dependencies: \n#{dependencies.duplicates}"

# given list of dependencies saved to file (as yml?), delete the first one from gradle file (once) and run command?
require 'yaml' # Built in, no gem required

# config = 'config/dependencies.yml'
# d = YAML::load_file(config) #Load
# d['content']['session'] = 2 #Modify
# File.open(config, 'w') {|f| f.write d.to_yaml } #Store

def remove_from_first_instance_in_gradle_files files, dependency_name
  files.files.each {|file|
    contents = File.open(file, "rb").read
    if(contents).include?(dependency_name) then
      File.open(file, "w") {|file| file.puts contents.gsub(dependency_name, "")}
    end
  }
end

def run_tests test_command
  puts "running tests with command: #{test_command}"
  `test_command`
end

dependencies.dependencies.each {|dep|
  remove_from_first_instance_in_gradle_files(gradles, dep)
  run_tests(ARGV[1] || "gradle clean test")
}