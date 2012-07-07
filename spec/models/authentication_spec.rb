require 'spec_helper'

describe Authentication do

  #it { should belongs_to :provider }
  before  { @auth = FactoryGirl.create(:authentication) }
  subject { @auth }
  #specify { @auth.should belongs_to :user }
  it { should be_valid }


  it "should has correct fields" do
    @auth.provider_id.should == 1
  end

  it "should have expected attributes" do
  end
end
