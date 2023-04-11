require 'rails_helper'

RSpec.describe CelebrationsController, type: :request do
  describe 'GET /deal/details' do
    context 'When deal with Id exists' do
      before do
        Tenant.create(kylas_tenant_id: 1, tenant_type: 'PAID', email: 'abc@abc.abc.com')
        @tenant = Tenant.first
        @deal = @tenant.deals.new(kylas_entity_id: 1, status: 'CLOSED_WON', name: 'New Deal', company: 'New Company')
        @deal.save
        @id = @deal.id
      end
      it 'respond exist' do
        get "/deal/details?id=#{@id}"
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
        expect(json[:message]).to eq('SUCCESS')
      end
    end

    context 'When deal with id not exists' do
      it "Deal with given Id does'nt exist" do
        get '/deal/details?id=1'
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
        expect(json[:message]).to eq('INVALID')
      end
    end
  end
end
