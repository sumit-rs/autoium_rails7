module ApplicationHelper

  def error_class(resource, field_name)
    if resource.errors[field_name].present?
      return "is-invalid".html_safe
    else
      return "".html_safe
    end
  end
  def date_format(date)
    date.strftime('%d-%m-%Y %H:%M')
  end

  def user_full_name(user)
    user&.full_name || 'SYSTEM'
  end
  def get_environment
    Environment.where(id: params[:environment_id]).first || '#'
  end
end
