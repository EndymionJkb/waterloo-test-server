module ApplicationHelper
  DATE_FORMAT = '%b %d, %Y'
  SHORT_DATE_FORMAT = '%-m/%d/%y'
  
  def full_title(page_title)
    page_title.blank? ? "Waterloo Assessment Server" : "Waterloo Assessment server | #{page_title}"
  end
end
