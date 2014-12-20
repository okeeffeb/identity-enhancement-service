json.subject do
  json.call(@object, :shared_token, :name, :mail)
end

json.attributes @available_attributes do |attribute|
  json.call(attribute, :name, :value)
  identifiers = @provided_attributes.map(&:permitted_attribute)
                .select { |attr| attr.available_attribute == attribute }
                .map(&:provider).map(&:full_identifier).uniq
  json.providers identifiers
end
