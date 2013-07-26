module JsonSerializingModel
  def active_model_serializer
    "#{self.class.to_s}Serializer".constantize
  end

  def serialize_to_json(serializer=active_model_serializer)
    serializer.new(self).as_json.to_json
  end
end
