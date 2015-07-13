require "spec_helper"
require "./lib/filter/filter.rb"

describe Filter do
	it "removes block with round braces" do
		result = Filter.extract('hey (lalalay)')
		result.should == 'hey'
  end
  it "removes block with square braces" do 
		result = Filter.extract('need [to cut] this')
		result.should == 'need this'
  end
   it "removes extra spaces around and within string" do 
		result = Filter.extract('  extra  		 space   ')
		result.should == 'extra space'
  end
end