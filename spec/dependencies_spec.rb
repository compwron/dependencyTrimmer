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
end
