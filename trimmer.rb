require_relative 'lib/gradle_files'
require_relative 'lib/dependencies'

gradles = GradleFiles.new(ARGV[0] || ".")

puts "Detected gradle files: \n#{gradles.pretty}\n\n"

dependencies = Dependencies.new(gradles.files)

puts "Detected #{dependencies.count} dependencies:
     \n#{dependencies.pretty}\n"

puts "\nPossible duplicate dependencies: \n#{dependencies.duplicates}"