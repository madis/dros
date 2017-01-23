module ApplicationHelper
  def flash_class(level)
    level_class =
      case level.to_sym
      when :notice then 'info'
      when :error then 'danger'
      when :success then 'success'
      else 'warning'
      end
    "alert alert-#{level_class} alert-with-icon"
  end

  def slug
    "#{params[:owner]}/#{params[:repo]}"
  end
end
