# frozen_string_literal: true

json.links do
  json.self organization_url(organization)
end
json.extract! organization, :id, :name, :created_at, :updated_at
json.balance organization.balance.to_f
