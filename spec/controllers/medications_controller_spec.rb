describe MedicationsController do
  describe '#print_reminders' do
    let(:user) { FactoryGirl.create(:user1) }

    subject { controller.print_reminders(medication) }

    describe 'when medication has no reminders' do
      let(:medication) { FactoryGirl.create(:medication, userid: user.id) }

      it 'is empty' do
        expect(subject).to eq('')
      end
    end

    describe 'when medication has refill reminder' do
      let(:medication) { FactoryGirl.create(:medication, :with_refill_reminder, userid: user.id) }

      it 'prints the reminder' do
        expect(subject).to eq('<div class="small_margin_top"><i class="fa fa-bell small_margin_right"></i>Refill reminder email</div>')
      end
    end

    describe 'when medication has daily reminder' do
      let(:medication) { FactoryGirl.create(:medication, :with_daily_reminder, userid: user.id) }

      it 'prints the reminders' do
        expect(subject).to eq('<div class="small_margin_top"><i class="fa fa-bell small_margin_right"></i>Daily reminder email</div>')
      end
    end

    describe 'when medication has both reminders' do
      let(:medication) { FactoryGirl.create(:medication, :with_both_reminders, userid: user.id) }

      it 'prints the reminders' do
        expect(subject).to eq('<div class="small_margin_top"><i class="fa fa-bell small_margin_right"></i>Refill reminder email, Daily reminder email</div>')
      end
    end

    describe 'DELETE #destroy' do
      let(:user) { create(:user) }
      let!(:medication) { create(:medication, user: user) }

      context 'when the user is logged in' do
        include_context :logged_in_user
        it 'deletes the medication' do
          expect { delete :destroy, params: { id: medication.id } }
            .to change(Medication, :count).by(-1)
        end

        it 'redirects to the medications index page' do
          delete :destroy, params: { id: medication.id }
          expect(response).to redirect_to medications_path
        end
      end

      context 'when the user is not logged in' do
        before { delete :destroy, params: { id: medication.id } }
        it_behaves_like :with_no_logged_in_user
      end
    end
  end

  describe 'GET #index' do 
    let(:user) { create(:user) }
    let!(:medication) { create(:medication, user: user) }

    context 'when signed in' do 
      before { sign_in user }
      it 'renders index page' do 
        get :index 
        expect(response).to render_template(:index)  
      end 
    end 
    context 'when not signed in' do 
      before { get :index }
      it_behaves_like :with_no_logged_in_user
    end 
  end 

  describe 'GET #new' do 
    let(:user) { create(:user) }
    let(:medication) { create(:medication, user: user) }

    context 'when signed in' do 
      before { sign_in user }
      it 'renders the new page' do 
        get :new
        expect(response).to render_template(:new)
      end 
    end 

    context 'when not signed in' do 
      before { get :new }
      it_behaves_like :with_no_logged_in_user
    end 
  end 

  describe 'GET #show' do 
    let(:user) { create(:user) }
    let(:medication) { create(:medication, user: user) }

    context 'when signed in' do 
      before { sign_in user }
      it 'render the show page when it belongs to the user' do
        medication.save! 
        get :show, params: { id: medication.id }
        expect(response).to render_template(:show)
      end 

      # it 'redirect when it is another users show page' do 
      #   medication.save!
      #   get :show, params: { id: medication.id + 1 }
      #   expect(response).to redirect_to medications_path
      # end 

    context 'when not signed in' do 
      before { get :show, params: { id: medication.id } }
      it_behaves_like :with_no_logged_in_user
    end 
  end 

  describe 'GET #edit' do 
    let(:user) { create(:user) }
    let(:medication) { create(:medication, user: user) }

    context 'when signed in' do 
      before { sign_in user }
      it 'renders the edit page' do 
        get :edit, params: { id: medication.id }
        expect(response).to render_template(:edit)
      end 
    end 

    context 'when not signed in' do 
      before { get :edit, params: { id: medication.id } }
      it_behaves_like :with_no_logged_in_user
    end 
  end 

  describe 'POST #create' do 
    let(:user) { create(:user) }
    let(:medication) { create(:medication, user: user) }
    let(:valid_medication_params) do 
      medication.attributes.merge(
        'name' => 'valid',
        'dosage' => '',
        'refill' => '',
        'userid' => user.id,
        'total' => '',
        'strength' => '',
        'dosage_unit' => '',
        'total_unit' => '',
        'strength_unit' => ''
      )

    context 'when signed in' do 
      before { sign_in user }
      post :create, params: { medication.name:  }
    end 

    context 'when not signed in' do 
      before { post :create }
      it_behaves_like :with_no_logged_in_user
    end 
  end 

  end 

end
