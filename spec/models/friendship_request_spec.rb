require 'spec_helper'

describe FriendshipRequest do
 
  { it {should ensure_inclusion_of(:status).in_array(%w[pending accepted rejected]) }


end
