# Start the ssh-agent.
eval "$(ssh-agent -s)"
# Add all private ssh-keys in ~/.ssh to ssh-agent.
grep -slR "PRIVATE" ~/.ssh/ | xargs ssh-add