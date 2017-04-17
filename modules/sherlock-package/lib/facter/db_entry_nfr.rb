Facter.add(:db_entry_nfr) do
  dbips = ["10.85.40.225"]
  ipSelected = dbips[rand(dbips.length)]
  setcode {
  	ipSelected
  }
end

