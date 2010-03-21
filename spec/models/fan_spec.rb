require 'spec_helper'
gem 'authlogic'

describe Fan do
	it { should validate_presence_of(:email) }
	it {
		Factory.create(:fan)
		should validate_uniqueness_of(:email)
	}
end
