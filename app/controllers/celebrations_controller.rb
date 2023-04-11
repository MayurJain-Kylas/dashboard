# frozen_string_literal: true

require 'net/http'

class CelebrationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index; end

  def details
    deal = Deal.find_by_id(params[:id])
    if deal.nil?
      render json: { status: 404, message: I18n.t(:invalid) }
    else
      deal.has_shown = true
      deal.save
      render json: { status: 200, message: I18n.t(:success), data: deal }
    end
  end

  def is_latest_deal_won
    deal = Deal.last
    if deal.nil?
      render json: { status: 404, message: I18n.t(:deal_not_found) }
    elsif deal.status == 'CLOSED_WON' and deal.has_shown == false
      render json: { status: 200, message: I18n.t(:deal_is_won), data: { id: deal.id, won: true } }
    else
      render json: { status: 200, message: I18n.t(:deal_is_not_won), data: { won: false } }
    end
  end

  def add_webhook
    uri = URI('https://api-qa.sling-dev.com/v1/webhooks')
    api_key = Rails.application.credentials.development.api_key
    body = { name: params[:webhook_name],
             requestType: 'POST',
             url: params[:webhook_url],
             authenticationType: 'NONE',
             authenticationKey: nil,
             events: %w[DEAL_CREATED DEAL_UPDATED DEAL_DELETED],
             active: true }
    headers = { 'Content-Type': 'application/json', 'api-key': api_key }
    begin
      response = Net::HTTP.post(uri, body.to_json, headers)
      if response.code.to_i == 201
        render json: { status: 200, message: I18n.t(:webhook_created) }
      else
        render json: { status: 400, message: I18n.t(:webhook_not_created) }
      end
    rescue StandardError => e
      render json: { status: 400, message: I18n.t(:failure), error: e.message }
    end
  end

  def celebration_webhook_call
    tenant = Tenant.find_by(kylas_tenant_id: deal_params[:kylas_tenant_id])
    if tenant.nil?
      render json: { status: 404, message: I18n.t(:tenant_not_found) }
    else
      begin
        deal = tenant.deals.new(deal_params.except(:kylas_tenant_id))
        if deal.save
          render json: { status: 200, message: I18n.t(:deal_added) }
        end
      rescue ArgumentError => e
        render json: { status: 400, message: e.message }
      end
    end
  end

  private

  def deal_params
    deal_params = {}
    deal_params[:kylas_entity_id] = params.dig(:entity).dig(:id)
    deal_params[:name] = params.dig(:entity).dig(:name)
    deal_params[:status] = params.dig(:entity).dig(:forecastingType)
    deal_params[:kylas_tenant_id] = params.dig(:tenantId)
    deal_params[:company] = params.dig(:entity).dig(:company)
    deal_params
  end
end
