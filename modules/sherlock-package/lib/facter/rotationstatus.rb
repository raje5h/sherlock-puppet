Facter.add(:rotationstatus) do
  setcode 'fk-w3-sherlock-admin status'
end

Facter.add(:hudsonrotationstatus) do
  setcode 'fk-w3-hudson-admin status'
end
