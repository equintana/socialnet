require 'spec_helper'

describe User, "validations" do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
end

describe User, "associations" do
  it { should have_many(:tweets) }
end