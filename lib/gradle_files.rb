class GradleFiles
	attr_reader :files
	def initialize root_dir
		@files = gradle_files(root_dir)
	end

	def gradle_files(dir)
	  Dir[File.join(dir, '**', '*')].reject { |p|
	    File.directory? p
	  }.reject { |p|
	    !p.include?(".gradle")
	  }.reject {|p|
	    p.include?("/out/")
	  }
	end
end