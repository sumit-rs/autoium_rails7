class SoftwareVersion < ApplicationRecord
  # -------------------------------------------------------------
  SOFTWARE_TYPES = { JAVA: 1, RAILS: 2, EXTENSION: 3 }

  # -------------------------------------------------------------
  validates :name, presence: true
  validates :release_date, presence: true

  # -------------------------------------------------------------
  def mac_link
    "softwares/autoium-mac-#{name}.zip"
  end
  def windows_link
    "softwares/autoium-windows-#{name}.zip"
  end
end
