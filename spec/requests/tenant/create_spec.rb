require 'rails_helper'

RSpec.describe TenantsController, type: :request do
  describe 'POST /tenants', type: :request do
    context "When Tenant already exists" do
      before do
        Tenant.create(kylas_tenant_id: 1, tenant_type: "PAID", email: "abc@abc.abc.com")
        @params = {
          "tenant": {
            "kylas_tenant_id": 1,
            "tenant_type": "PAID",
            "email": "abc@abc.abc.com"
          }
        }
      end 
      it 'respond tenant exists already' do 
        post '/tenants', params: @params 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(400)
        expect(json[:message]).to eq("FAILURE")
        expect(json[:reason]).to eq("Tenant already exist")
        expect(Tenant.count).to eq 1
      end
    end
    context "When Tenant data is invalid" do
      before do
        @params = {
          "tenant": {
            "kylas_tenant_id": 1,
            "tenant_type": "PAID",
            "email": "abc"
          }
        }
      end
      it ' Tenant should be not be added ' do
        post '/tenants', params: @params 
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(400)
        expect(json[:message]).to eq("FAILURE")
        expect(Tenant.count).to eq 0
      end
    end
    context "When Tenant data is valid" do
      before do
        @params = {
          "tenant": {
            "kylas_tenant_id": 1,
            "tenant_type": "PAID",
            "email": "abc@abc.com"
          }
        }
      end
      it 'Tenant should be added' do
        post '/tenants', params: @params
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
        expect(json[:message]).to eq("SUCCESS")
        expect(Tenant.count).to eq 1
      end
    end
  end
end
