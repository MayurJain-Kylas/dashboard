# frozen_string_literal: true

class Tenant < ApplicationRecord
  has_many :deals, dependent: :destroy
  enum tenant_type: { PAID: 0, FREE: 1 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :kylas_tenant_id, :email, :tenant_type, presence: true
end

