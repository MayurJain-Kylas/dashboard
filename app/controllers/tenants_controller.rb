# frozen_string_literal: true

class TenantsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    request_params = tenant_create_params
    if Tenant.exists?(kylas_tenant_id: request_params[:kylas_tenant_id])
      render json: { status: 400, message: I18n.t(:failure), reason: I18n.t(:tenant_already_exist) }
    else
      tenant = Tenant.new(request_params)
      if tenant.save
        render json: { status: 200, message: I18n.t(:success) }
      else
        render json: { status: 400, message: I18n.t(:failure) }
      end
    end
  end

  private

  def tenant_create_params
    params.require(:tenant).permit(:kylas_tenant_id, :email, :tenant_type)
  end
end
