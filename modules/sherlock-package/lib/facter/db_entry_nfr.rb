Facter.add(:db_entry_nfr) do
  dbips = ["10.85.225.53"]
  ipSelected = dbips[rand(dbips.length)]
  setcode {
  	ipSelected
  }
end

