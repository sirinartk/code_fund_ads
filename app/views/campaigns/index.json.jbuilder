# frozen_string_literal: true

json.links do
  json.self campaigns_url
end
json.data @campaigns do |campaign|
  json.type "campaign"
  json.extract! campaign, :id, :name, :end_date, :status
  json.total_budget campaign.total_budget.to_f
  json.total_consumed_budget campaign.total_consumed_budget.to_f
  json.remaining_budget campaign.remaining_budget.to_f
  json.relationships do
    json.organization do
      json.links do
        json.self organization_url(campaign.user&.organization)
      end
      json.extract! campaign.user&.organization, :id, :name, :created_at, :updated_at
      json.balance campaign.user&.organization.balance.to_f
    end
  end
  json.links do
    json.self campaign_url(campaign)
  end
end
json.count @campaigns.count
