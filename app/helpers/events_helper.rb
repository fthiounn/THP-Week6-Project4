module EventsHelper
  def get_end_date(event)
    @event.start_date + @event.duration*60
  end
end
