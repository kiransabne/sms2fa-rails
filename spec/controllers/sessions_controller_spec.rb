require 'rails_helper'

describe SessionsController do
  describe "#create" do
    let(:user) { create(:user) }

    context 'when credentials are correct' do
      before do
        allow(ConfirmationSender)
          .to receive(:send_confirmation_message_to)
          .with(user)

        post :create, { email: user.email, password: user.password }
      end

      it 'creates a user' do
        expect(session[:user_id]).to be user.id
      end

      it 'send a code to confirm' do
        expect(ConfirmationSender)
          .to have_received(:send_confirmation_message_to)
          .with(user)
          .once
      end

      it 'renders confirmation template' do
        expect(response).to render_template('users/confirmation')
      end
    end

    context 'when credentials are incorrect' do
      it 'renders new template' do
        allow(ConfirmationSender)
          .to receive(:send_confirmation_message_to)
          .with(user)

        post :create, { email: user.email, password: 'wrong_password' }

        expect(response).to render_template(:new)
      end
    end
  end

  describe "#destroy" do
    it "destroy the sessions" do
      get :destroy

      expect(session[:user_id]).to be nil
      expect(session[:authenticated]).to be nil
    end
  end
end
