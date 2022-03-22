require "date"
require "fixnum"

class DateRangeFormatter
  def initialize(start_date, end_date, start_time = nil, end_time = nil)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @start_time = start_time
    @end_time = end_time
  end

  def to_s
    if input_range_on_same_day?
      format_range_for_same_day
    elsif input_range_in_same_month?
      format_range_for_same_month
    elsif input_range_in_same_year?
      format_range_for_same_year
    else
      format_range_for_different_year
    end
  end

  private

  def input_range_on_same_day?
    @start_date == @end_date
  end

  def input_range_in_same_month?
    @start_date.month == @end_date.month && @start_date.year == @end_date.year
  end

  def input_range_in_same_year?
    @start_date.year == @end_date.year
  end

  def no_times_given?
    !@start_time && !@end_time
  end

  def format_same_month_range_without_times
    @start_date.strftime("#{@start_date.day.ordinalize} - #{@end_date.day.ordinalize} %B %Y")
  end

  def format_same_year_range_without_times
    @start_date.strftime("#{@start_date.day.ordinalize} %B - ") +
      @end_date.strftime("#{@end_date.day.ordinalize} %B %Y")
  end

  def format_dates_only
    "#{full_start_date} - #{full_end_date}"
  end

  def format_range_for_same_day
    if @start_time && @end_time
      "#{date_at_time(full_start_date, @start_time)} to #{@end_time}"
    elsif @start_time
      date_at_time(full_start_date, @start_time)
    elsif @end_time
      "#{full_start_date} until #{@end_time}"
    else
      full_start_date
    end
  end

  def format_range_for_same_month
    if no_times_given?
      format_same_month_range_without_times
    else
      format_range_with_start_and_end_dates
    end
  end

  def format_range_for_same_year
    if no_times_given?
      format_same_year_range_without_times
    else
      format_range_with_start_and_end_dates
    end
  end

  def format_range_for_different_year
    if no_times_given?
      format_dates_only
    else
      format_range_with_start_and_end_dates
    end
  end

  def format_range_with_start_and_end_dates
    if @start_time && @end_time
      "#{date_at_time(full_start_date, @start_time)} - #{date_at_time(full_end_date, @end_time)}"
    elsif @start_time
      "#{date_at_time(full_start_date, @start_time)} - #{full_end_date}"
    elsif @end_time
      "#{full_start_date} - #{full_end_date} at #{@end_time}"
    end
  end

  def date_at_time(date, time)
    "#{date} at #{time}"
  end

  def full_start_date
    @start_date.strftime("#{@start_date.day.ordinalize} %B %Y")
  end

  def full_end_date
    @end_date.strftime("#{@end_date.day.ordinalize} %B %Y")
  end
end
