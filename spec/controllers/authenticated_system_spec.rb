require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper
include AuthenticatedSystem
def action_name() end

describe SessionsController do
	fixtures :members, :sections

	before do
		# FIXME -- sessions controller not testing xml logins 
		stub!(:authenticate_with_http_basic).and_return nil
	end		
	describe "logout_killing_session!" do
		before do
			login_as :quentin
			stub!(:reset_session)
		end
		it 'resets the session'         do should_receive(:reset_session);				 logout_killing_session! end
		it 'kills my auth_token cookie' do should_receive(:kill_remember_cookie!); logout_killing_session! end
		it 'nils the current member'    do logout_killing_session!; current_member.should be_nil end
		it 'kills :member_id session' do
			session.stub!(:[]=)
			session.should_receive(:[]=).with(:member_id, nil).at_least(:once)
			logout_killing_session!
		end
		it 'forgets me' do		
			current_member.remember_me
			current_member.remember_token.should_not be_nil;
			current_member.remember_token_expires_at.should_not be_nil
			members(:quentin).reload.remember_token.should_not be_nil;
			members(:quentin).reload.remember_token_expires_at.should_not be_nil
			logout_killing_session!
			members(:quentin).reload.remember_token.should be_nil;
			members(:quentin).reload.remember_token_expires_at.should be_nil
		end
	end

	describe "logout_keeping_session!" do
		before do
			login_as :quentin
			stub!(:reset_session)
		end
		it 'does not reset the session' do should_not_receive(:reset_session);	 logout_keeping_session! end
		it 'kills my auth_token cookie' do should_receive(:kill_remember_cookie!); logout_keeping_session! end
		it 'nils the current member'    do logout_keeping_session!; current_member.should be_nil end
		it 'kills :member_id session' do
			session.stub!(:[]=)
			session.should_receive(:[]=).with(:member_id, nil).at_least(:once)
			logout_keeping_session!
		end
		it 'forgets me' do		
			current_member.remember_me
			current_member.remember_token.should_not be_nil;
			current_member.remember_token_expires_at.should_not be_nil
			members(:quentin).reload.remember_token.should_not be_nil;
			members(:quentin).reload.remember_token_expires_at.should_not be_nil
			logout_keeping_session!
			members(:quentin).reload.remember_token.should be_nil;
			members(:quentin).reload.remember_token_expires_at.should be_nil
		end
	end
	
	describe 'When logged out' do 
		it "should not be authorized?" do
			authorized?().should be_false
		end		
	end

	#
	# Cookie Login
	#
	context 'with a valid token expiry' do
		before do
			@member = stub_model(Member, {:save => true, :remember_token => 'hello!', :remember_token_expires_at => 5.minutes.from_now})
			Member.stub!(:find_by_remember_token).with('hello!').and_return(@member)
		end
		
		it 'authenticates successfully with a valid cookie' do
			stub!(:cookies).and_return({ :auth_token => 'hello!' })
			logged_in?.should be_true
		end

		it 'fails to authenticate with a bad cookie' do
			@member = stub_model(Member, {:save => true, :remember_token => 'hello!', :remember_token_expires_at => 5.minutes.from_now})
			should_receive(:cookies).at_least(:once).and_return({ :auth_token => 'i_haxxor_joo' })
			logged_in?.should_not be_true
		end

		it 'fails to authenticate with no cookie' do
			@member = stub_model(Member, {:save => true, :remember_token => 'hello!', :remember_token_expires_at => 5.minutes.from_now})
			should_receive(:cookies).at_least(:once).and_return({ })
			logged_in?.should_not be_true
		end
	end
	
	context 'with a past cookie expiry' do
		before do
			@member = stub_model(Member, {:save => true, :remember_token => 'hello!', :remember_token_expires_at => 5.minutes.ago})
			Member.stub!(:find_by_remember_token).with('hello!').and_return(@member)
		end
		
		it 'fails a cookie login' do
			stub!(:cookies).and_return({ :auth_token => 'hello!' })
			logged_in?.should_not be_true
		end
	end
	
end
