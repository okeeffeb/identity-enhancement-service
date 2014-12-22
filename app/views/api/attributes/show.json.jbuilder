json.subject do
  json.call(@object, :shared_token, :name, :mail)
end

json.attributes @attributes_map do |(name, value), providers|
  json.name name
  json.value value
  json.providers providers.map(&:full_identifier)
end
