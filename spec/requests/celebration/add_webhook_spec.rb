require 'rails_helper'

RSpec.describe CelebrationsController, type: :request do
  describe 'POST /add_webhook' do
    context "When User Credentials and url is valid are valid" do
      before do
        @params = {
          "webhook_name": "Name",
          "webhook_url": "http://asdasd.asd"
        }
      end
      it 'Webhook should be added' do
        post '/add_webhook', params: @params 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
      end
    end
    context "When URL is invalid" do
      before do
        @params = {
          "webhook_name": "Name",
          "webhook_url": "asdasd.asd"
        }
      end
      it 'Webhook should not be added' do
        post '/add_webhook', params: @params 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(400)
      end
    end
    context "When api hit fails" do
      before do
        @params = {
          "webhook_name": "Name",
          "webhook_url": "asdasd.asd"
        }
      end
      it 'Webhook should not be added' do
        expect(Net::HTTP).to receive(:post).and_raise( StandardError )
        post '/add_webhook', params: @params 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(400)
      end
    end
  end
end
