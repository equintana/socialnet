require 'spec_helper'

describe Tweet, "validations"  do

	it { should validate_presence_of(:tweet) }

	it { should ensure_length_of(:tweet).is_at_most(140) }

	it { should validate_uniqueness_of(:tweet).case_insensitive }

end
