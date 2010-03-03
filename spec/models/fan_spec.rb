require 'spec_helper'
gem 'authlogic'

describe Fan do
	it { should validate_presence_of(:email) }
end
