Facter.add(:db_entry) do
  dbips = ["10.32.241.213" , "10.33.81.152" , "10.32.218.109" , "10.33.93.153" , "10.33.109.162" , "10.33.17.160"]
  ipSelected = dbips[rand(dbips.length)]
  setcode ipSelected
end

