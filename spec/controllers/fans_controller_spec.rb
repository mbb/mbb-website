require 'spec_helper'

describe FansController do
	it { should route(:get,		'/fans/new' ).to(:controller => :fans, :action => :new) }
	it { should route(:post,	 '/fans'		 ).to(:controller => :fans, :action => :create) }
	it { should route(:delete, '/fans/1'	 ).to(:controller => :fans, :action => :destroy, :id => 1) }
	
	describe "#create" do
		context "with valid params" do
			before :each do
				Fan.stub!(:new).and_return(mock_model(Fan, :save => true))
			end
			
			it 'should redirect back to the news section' do
				post :create, :fan => {}
				response.should redirect_to(news_items_url)
			end
			
			it 'should thank the user for signing up!' do
				post :create, :fan => {}
				flash[:notice].should =~ /thanks|thank you/i
			end
		end
		
		context 'when re-registering a fan (non-unique e-mail)' do
			before :each do
				existing_fan = Factory.create(:fan)
				another_fan = Factory.build(:fan, :email => existing_fan.email)
				Fan.stub!(:new).and_return(another_fan)
			end
			
			it 'should redirect back to the news section' do
				post :create, :fan => {}
				response.should redirect_to(news_items_url)
			end
			
			it 'should thank the user for signing up (even though nothing was done)!' do
				post :create, :fan => {}
				flash[:notice].should =~ /thanks|thank you/i
			end
		end
		
		context "with invalid params" do
			before :each do
				bad_fan = Factory.build(:fan, :email => 'nonsense')
				Fan.stub!(:new).and_return(bad_fan)
			end
			
			it 'should render the new fan page again' do
				post :create, :fan => {}
				response.should render_template('new')
			end
		end
	end
	
	describe "DELETE destroy" do
		it 'destroys the requested fan' do
			Fan.should_receive(:find).with("37").and_return(mock_fan)
			mock_fan.should_receive(:destroy)
			delete :destroy, :id => "37"
		end

		it 'should redirect to the news page' do
			Fan.stub!(:find).and_return(mock_fan(:destroy => true))
			delete :destroy, :id => "1"
			response.should redirect_to(news_items_url)
		end
		
		it 'should thank the user cordially' do
			Fan.stub!(:find).and_return(mock_fan(:destroy => true))
			delete :destroy, :id => '1'
			flash[:notice].should =~ /thanks|thank you/i
		end
	end
	
	private
		def mock_fan(stubs = {})
			@fan ||= mock_model(Fan, stubs)
		end
end
