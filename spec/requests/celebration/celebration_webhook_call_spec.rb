require 'rails_helper'

RSpec.describe CelebrationsController, type: :request do
  describe 'POST /deal/celebration_webhook_call' do
    context 'When tenant doesnt exist' do
      before do
        @params = {
          "entity": {
            "id": 37_400,
            "name": 'Order of 40000 Pens',
            "ownedBy": {
              "id": 8614,
              "name": 'Hardik Jade'
            },
            "forecastingType": 'CLOSED_LOST',
            "company": nil,
            "createdAt": '2023-03-28T13:26:25.650Z',
            "updatedBy": {
              "id": 8614,
              "name": 'Hardik Jade'
            },
            "updatedAt": '2023-03-28T13:28:46.454Z',
            "customFieldValues": {},
            "products": [],
            "createdViaId": '8614',
            "createdViaName": 'User',
            "createdViaType": 'Web',
            "updatedViaId": '8614',
            "updatedViaName": 'User',
            "updatedViaType": 'Web'
          },
          "entityType": 'deal',
          "event": 'DEAL_UPDATED',
          "webhookId": 603,
          "tenantId": 4444
        }
      end
      it 'Deal should not be added' do
        post '/deal/celebration_webhook_call', params: @params
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(404)
        expect(json[:message]).to eq('Tenant not found')
      end
    end
    context 'When tenant exists' do
      before do
        Tenant.create(kylas_tenant_id: 4444, tenant_type: 'PAID', email: 'abc@abc.abc.com')
        @params = {
          "entity": {
            "id": 37_400,
            "name": 'Order of 40000 Pens',
            "ownedBy": {
              "id": 8614,
              "name": 'Hardik Jade'
            },
            "forecastingType": 'CLOSED_LOST',
            "company": nil,
            "createdAt": '2023-03-28T13:26:25.650Z',
            "updatedBy": {
              "id": 8614,
              "name": 'Hardik Jade'
            },
            "updatedAt": '2023-03-28T13:28:46.454Z',
            "customFieldValues": {},
            "products": [],
            "createdViaId": '8614',
            "createdViaName": 'User',
            "createdViaType": 'Web',
            "updatedViaId": '8614',
            "updatedViaName": 'User',
            "updatedViaType": 'Web'
          },
          "entityType": 'deal',
          "event": 'DEAL_UPDATED',
          "webhookId": 603,
          "tenantId": 4444
        }
      end
      it 'Deal should Added' do
        post '/deal/celebration_webhook_call', params: @params
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(200)
        expect(json[:message]).to eq('Deal Added Successfully')
      end
    end
    context "When a deal is not valid" do
      before do
        Tenant.create(kylas_tenant_id: 4444, tenant_type: 'PAID', email: 'abc@abc.abc.com')
        @params = {
          "entity": {
            "id": 37_400,
            "name": 'Order of 40000 Pens',
            "ownedBy": {
              "id": 8614,
              "name": 'Hardik Jade'
            },
            "forecastingType": 'BAD',
            "company": nil,
            "createdAt": '2023-03-28T13:26:25.650Z',
            "updatedBy": {
              "id": 8614,
              "name": 'Hardik Jade'
            },
            "updatedAt": '2023-03-28T13:28:46.454Z',
            "customFieldValues": {},
            "products": [],
            "createdViaId": '8614',
            "createdViaName": 'User',
            "createdViaType": 'Web',
            "updatedViaId": '8614',
            "updatedViaName": 'User',
            "updatedViaType": 'Web'
          },
          "entityType": 'deal',
          "event": 'DEAL_UPDATED',
          "webhookId": 603,
          "tenantId": 4444
        }
      end
      it "Should not be added" do
        post '/deal/celebration_webhook_call', params: @params
        json = JSON.parse(response.body).deep_symbolize_keys
        expect(json[:status]).to eq(400)
        expect(json[:message]).to eq("'BAD' is not a valid status")
      end
    end
  end
end
