class ClaimSerializer < ActiveModel::Serializer
  attributes :id,
    :client_id,
    :created_at,
    :donation,
    :qr_code,
    :updated_at
end
