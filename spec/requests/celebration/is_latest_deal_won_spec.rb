require 'rails_helper'

RSpec.describe CelebrationsController, type: :request do
  describe 'GET /deal/is_latest_deal_won' do
    context "When the lastest Deal is won" do
      before do
        Tenant.create(kylas_tenant_id: 1, tenant_type: "PAID", email: "abc@abc.abc.com")
        @tenant = Tenant.first
        @deal = @tenant.deals.new( kylas_entity_id: 1, status: "CLOSED_WON", name: "New Deal", company:"New Company" )
        @deal.save
      end 
      it 'respond deal won' do 
        get '/deal/is_latest_deal_won'
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
        expect(json[:message]).to eq("Latest Deal is Won")
        expect(json[:data][:won]).to eq(true)
      end
    end
    context "When Latest deal is not won" do
      before do
        Tenant.create(kylas_tenant_id: 1, tenant_type: "PAID", email: "abc@abc.abc.com")
        @tenant = Tenant.first
        @deal = @tenant.deals.new(kylas_entity_id: 1, status: "CLOSED_LOST")
        @deal.save
      end
      it 'Latest Deal is not won' do
        get '/deal/is_latest_deal_won'
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
        expect(json[:message]).to eq("Latest Deal is Not Won")
        expect(json[:data][:won]).to eq(false)
      end
    end
    context "When No deal is present" do
      before do
        Deal.delete_all
      end
      it 'No deal should be found' do
        get '/deal/is_latest_deal_won'
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
        expect(json[:message]).to eq('Deal not found')
      end
    end
  end
end
