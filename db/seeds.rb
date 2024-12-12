# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
existing_set = ResultsDictionary.pluck(:id)
if existing_set.count != ResultsDictionary::STATUS.count
  ResultsDictionary::STATUS.each do |key, status|
    ResultsDictionary.create(description: key, id: status) unless existing_set.include?(key)
  end
end

if Browser.count.zero?
  Browser.create(id: Browser::CHROME_ID, name: Browser::CHROME)
  Browser.create(id: Browser::FIREFOX_ID, name: Browser::FIREFOX)
  Browser.create(id: Browser::EDGE_ID, name: Browser::EDGE)
  Browser.create(id: Browser::SAFARI, name: Browser::SAFARI)
end
