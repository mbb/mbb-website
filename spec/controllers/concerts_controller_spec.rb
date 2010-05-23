require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConcertsController do
	it { should route(:get,  '/concerts/new'     ).to(:controller => :concerts, :action => :new     ) }
	it { should route(:post, '/concerts'         ).to(:controller => :concerts, :action => :create  ) }
	it { should route(:get,  '/concerts/past'    ).to(:controller => :concerts, :action => :past    ) }
	it { should route(:get,  '/concerts/next'    ).to(:controller => :concerts, :action => :next    ) }
	it { should route(:get,  '/concerts/upcoming').to(:controller => :concerts, :action => :upcoming) }
	
	describe '#new' do
		context 'when NOT logged in' do
			before { logout }
			
			it 'should redirect to the login page' do
				get :new
				response.should redirect_to(login_url)
			end
		end
		
		context 'when logged in as an unprivileged member' do
			before { login({}, {:privileged? => false}) }
			
			it 'should deny access' do
				get :new
				response.code.should == '403' # Forbidden
				response.should_not render_template('concerts/new')
			end
		end
		
		context 'when logged in as a privileged member' do
			before { login({}, {:privileged? => true}) }
			
			it 'should permit access' do
				get :new
				response.should be_success
				response.should render_template('concerts/new')
			end
		end
	end
	
	describe '#create' do
		context 'when NOT logged in' do
			before { logout }
			
			it 'should redirect to the login page' do
				post :create
				response.should redirect_to(login_url)
			end
		end
		
		context 'when logged in as an unprivileged member' do
			before { login({}, {:privileged? => false}) }
			
			it 'should deny access' do
				post :create
				response.code.should == '403' # Forbidden
				response.should_not render_template('concerts/new')
			end
		end
		
		context 'when logged in as a privileged member' do
			before { login({}, {:privileged? => true}) }
			
			context 'and submitting valid data' do
				before do
					@the_concert = mock_model(Concert, :save => true)
					Concert.should_receive(:new).with('these' => :attributes).and_return(@the_concert)
				end
				
				it 'should redirect to the concerts list' do
					post :create, :concert => {:these => :attributes}
					response.should redirect_to(concerts_path)
				end
				
				it 'should note the posted concert in a notice' do
					post :create, :concert => {:these => :attributes}
					flash[:notice].should_not be_nil
				end
			end
			
			context 'but submitting invalid data' do
				before do
					@the_concert = mock_model(Concert, :save => false)
					Concert.should_receive(:new).with('these' => :attributes).and_return(@the_concert)
				end
				
				it 'should re-render the concert creation form' do
					post :create, :concert => {:these => :attributes}
					response.should render_template('concerts/new')
				end
			end
		end
	end
end
