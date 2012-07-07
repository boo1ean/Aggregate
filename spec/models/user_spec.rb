require 'spec_helper'

describe User do
  before { @user = FactoryGirl.create(:user_with_auth) }

  describe "factories test" do
    it "should create 5 auth" do
      @user.authentications.count.should eq(5)
    end
  end

  describe "#missing_providers" do
    it "should return 1" do
      FactoryGirl.create(:provider)
      @user.missing_providers.count.should eq(1)
    end

    it "should return 10" do
      FactoryGirl.create_list(:provider, 10)
      @user.missing_providers.count.should eq(10)
    end
  end
end
