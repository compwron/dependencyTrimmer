require_relative "spec_helper"

describe Dependencies do
  dependencies = Dependencies.new([])
  describe "#get_dependencies" do
    it "should not detect dependency in empty file text" do
      dependencies.get_dependencies("").should be_empty
    end

    it "should detect one dependency" do
      expect(dependencies.get_dependencies("'junit:junit:4.11'")).to include("junit:junit")
    end
  end

  describe "#duplicates" do
    it "should not detect duplicate in empty set" do
      dependencies.duplicates.should be_empty
    end
    
    gradle_dupes = "has_duplicates.gradle"
    
    after do
    `rm #{gradle_dupes}`
    end

    it "should detect duplicate when there is one duplicate" do
      add_junit_command = "echo \"'junit:junit:4.11'\" >> #{gradle_dupes}"
      `#{add_junit_command} ; #{add_junit_command}`
      dupes = Dependencies.new([gradle_dupes]).duplicates
      expect(dupes).to eq("found 2 times: junit:junit")
    end
  end
end
