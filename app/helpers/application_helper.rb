module ApplicationHelper

	ALERT_PREFIX = {:success => 'Sucesso',
									:info => 'Info',
									:warning => 'Atenção',
									:danger => 'Erro'
									}

	def alert_flash_message
    alert_html = nil
 
    [:success, :info, :warning, :danger].each do |type|
      if flash[type]
      	alert_html = "<div class='alert alert-#{type} alert-dismissible fade in floatAlert'><button type=''button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>×</span></button><strong>#{ALERT_PREFIX[type]}!</strong> #{flash[type]}</div>"
      end
    end

    alert_html
  end

  def menu_active arr_controller
    arr_controller.include?(controller.controller_name) ? "active" : ""
  end

  def notification_count
    @notification ||= Client.pending.count
  end

  def str_company_path 
    Company.count > 0 ? edit_company_path(Company.first.id) : new_company_path
  end

  def hr_table_row
    "<hr style='margin:5px;'>".html_safe
  end
end