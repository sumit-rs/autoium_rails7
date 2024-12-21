class Browser < ApplicationRecord
  # -------------------------------------------------------------
  # selenium java app has configure hard coded id for the browser so we are following same
  CHROME = 'CHROME' #id =1
  FIREFOX = 'FIREFOX' #id =2
  SAFARI = 'SAFARI' #id = 3
  EDGE = 'EDGE' #id = 4

  CHROME_ID = 1
  FIREFOX_ID = 2
  SAFARI_ID = 3
  EDGE_ID = 4
  BROWSERS = {CHROME => CHROME_ID, FIREFOX => FIREFOX_ID, SAFARI => SAFARI_ID, EDGE => EDGE_ID}

  # -------------------------------------------------------------
  validates :name, presence: true

  # -------------------------------------------------------------
  def self.populate_default_data
    BROWSERS.keys.each do |browser|
      Browser.create(id: BROWSERS[browser] , name: browser, is_active: true)
    end
  end
end
