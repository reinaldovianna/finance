module RevenuesHelper

  def marketplaces client, revenues
    client.channel_stores.map do |channel|
      next unless channel.active?

      channel.marketplace.name if channel_revenues_equals?(channel, revenues)
    end.compact
  end
  
  def channel_revenues_equals? channel, revenues
    channel.store.name == revenues[:store_name] &&
    channel.cnpj.vat_number == revenues[:channel_cnpj_number] &&
    channel.date_payment.strftime("%d/%m/%Y") == revenues[:date_payment] &&
    channel.additional_time_unabbreviated == revenues[:additional_time]
  end

  def list_revenues client
    revenues_hash(client).uniq
  end

  def revenues_hash client
    sort_revenues(client).map do |channel|
      {
        :channel_cnpj_id => channel.cnpj.id,
        :channel_cnpj_number => channel.cnpj.vat_number,
        :store_name => channel.store.name,
        :date_payment => channel.date_payment.strftime("%d/%m/%Y"),
        :additional_time => channel.additional_time_unabbreviated
      }
    end
  end

  def sort_revenues client
    client.channel_stores.sort_by{|channel| "#{channel.cnpj.vat_number+channel.store.name+channel.payday.to_s+channel.additional_time_day.to_s}" }
  end

  def calculate_weekday_range(date1, date2)
    day_count = 0
    (date1+1...date2+1).each{ |date| day_count += 1 if (1..5).include?(date.wday) && !date.holiday?(:br, :informal)}
    day_count
  end

  def channel_sort_by_cnpj_monthly_payment client
    client.channel_stores.select(&:active?).sort_by{|c| "#{c.cnpj.vat_number}{c.monthly_payment" }
  end

  def should_skip_channel? channel_store, cnpj
    channel_store.cnpj.vat_number != cnpj || !channel_store.active?
  end

  def cnpj_changed? channel
    @old_cnpj && @old_cnpj != channel.cnpj.vat_number
  end
  
  def additional_time_date_changed? channel
    @old_additional_time_date && @old_additional_time_date != channel.additional_time_date
  end

  def is_last_channel? channel, arr_channel
    channel.id == arr_channel.last.id
  end
  # def parse_working_days date
  #   (1..5).include?(date.wday) (date + 
  # end

  #    date_revenues = (1..5).include?(date.wday) ? 
  #    day_count = 0
  #    (date1+1...date2+1).each{ |date| day_count += 1 if (1..5).include?(date.wday) && !date.holiday?(:br, :informal)}
  #    day_count

end
