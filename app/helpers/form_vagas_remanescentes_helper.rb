module FormVagasRemanescentesHelper

  def session_activity table_info, activity_id
    last_response = table_info[:last_response]
    if last_response and last_response[table_info[:type]]
      return last_response[table_info[:type]].flat_map {|i| i[1] }.select { |k| k['activityId'].to_s == activity_id.to_s }.first
    end
    nil
  end

  def value_of_last_response_or_current_user field, last_response, current_user
    return last_response[field] if last_response
    # or
    if current_user
      return field == 'name' ? current_user.name : current_user.email
    end
    ""
  end

end
