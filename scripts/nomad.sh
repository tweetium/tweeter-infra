export NOMAD_ADDR=$(terraform output nomad_ipv4_address)

if [[ $? != 0 ]]; then
  echo "Failed to get the nomad_ipv4_address via terraform, is your terraform state up-to-date?"
  exit 1
fi

nomad-real $@
