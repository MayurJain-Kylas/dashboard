require 'rails_helper'

RSpec.describe Tenant, type: :model do
  let(:tenant) do
    Tenant.new(kylas_tenant_id: 4023, email: 'tenant_user@gmail.com', tenant_type: 'PAID')
  end

  let(:deal_1) do
    tenant.deals.new(name: 'Order of 10 Laptops', status: 'CLOSED_WON', tenant_id: 4023, company: 'XYZ Corporation', kylas_entity_id: 1234)
  end

  let(:deal_2) do
    tenant.deals.new(name: 'Order of hsoftware support', status: 'CLOSED_WON', tenant_id: 4023, company: 'XYZ Corporation', kylas_entity_id: 1235)
  end

  before { 
    tenant
    deal_1.save
    deal_2.save
  }

  describe '#validations' do

    context "created new tenant with no attributes" do
      it "is not valid" do
        expect(Tenant.new).to_not be_valid
      end
    end

    context "created new tenant with no email" do
      it "is not valid" do
        tenant = Tenant.new(kylas_tenant_id: 1)
        expect(tenant).to_not be_valid
      end
    end

    context "created new tenant with no email" do
      it "is not valid" do
        tenant = Tenant.new(kylas_tenant_id: 1)
        expect(tenant).to_not be_valid
      end
    end

    context "created new tenant with invalid email" do
      let(:tenant_invalid_email) do
        Tenant.new(kylas_tenant_id: 1, email: 'tenant_u@ser@gmail.com', tenant_type: 'PAID')
      end

      it "is not valid" do
        tenant_invalid_email.valid?
        expect(tenant_invalid_email.errors.messages[:email][0]).to include("is invalid")
      end
    end
  end

  describe '#associations' do

    before do
      tenant.deals << [deal_1, deal_2]
    end

    context "tenant should have many deals" do
      it "should have 1st deal" do
        d = Tenant.reflect_on_association(:deals)
        expect(d.macro).to eq(:has_many)
      end

      it "should have 2nd deal" do
        d = Tenant.reflect_on_association(:deals)
        expect(d.macro).to eq(:has_many)
      end  
    end
  end  
end