class Browser < ApplicationRecord
  # -------------------------------------------------------------
  # selenium java app has configure hard coded id for the browser so we are following same
  CHROME = 'CHROME' #id =1
  FIREFOX = 'FIREFOX' #id =2
  SAFARI = 'SAFARI' #id = 3
  EDGE = 'EDGE' #id = 3
  BROWSERS = [CHROME, FIREFOX, EDGE, SAFARI]

  # -------------------------------------------------------------
  validates :name, presence: true

  # -------------------------------------------------------------
  def self.populate_default_data
    BROWSERS.each do |browser|
      Browser.create(name: browser, is_active: true)
    end
  end
end
