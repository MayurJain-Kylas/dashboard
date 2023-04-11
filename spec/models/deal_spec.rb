require 'rails_helper'

RSpec.describe Deal, type: :model do
  let(:tenant) do
    Tenant.create(kylas_tenant_id: 4023, email: 'jondoe@gmail.com', tenant_type: 'FREE')
  end

  before { tenant }
  
  let(:deal) do
    tenant.deals.new(name: 'Jon Doe', status: 'CLOSED_WON', company: 'Vista', kylas_entity_id: 1234)
  end

  describe '#validations' do
    context 'when all attributes are valid' do
      it 'then it is valid' do
        expect(deal).to be_valid
      end
    end

    context 'when tenant is missing' do
      before { deal.tenant_id = 1111 }
      it 'then it is not valid' do
        expect(deal).not_to be_valid
      end

      it 'then it is not valid and shows error message' do
        deal.valid?
        expect(deal.errors.messages[:tenant]).to include('must exist')
      end
    end
  end

  describe '#associations' do
    it 'should belongs to tenant' do
      d = Deal.reflect_on_association(:tenant)
      expect(d.macro).to eq(:belongs_to)
    end
  end

end
