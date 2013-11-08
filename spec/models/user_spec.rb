require 'spec_helper'

describe User, "validations" do
  it { should validate_presence_of(:name) }
end

describe User, "associations" do
  it { should have_many(:tweets) }
end