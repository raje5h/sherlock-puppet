Facter.add(:db_entry) do
  dbips = ["10.33.165.232" , "10.33.225.225" , "10.32.237.210" , "10.33.129.221" , "10.32.253.205" , "10.32.249.175"]
  ipSelected = dbips[rand(dbips.length)]
  setcode {
  	ipSelected
  }
end

