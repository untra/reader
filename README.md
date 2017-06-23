# Reader

**TODO: Add description**

## Installation
```
# clone the repo
git clone https://github.com/untra/reader.git
# cd into the directory
cd reader
# get any dependencies
mix deps.get
# start the elixir terminal with the project loaded into memory:
iex -S mix
# start the erlang observer for detailed stats of cpu process consumption
# I recommend looking through some of the tabs in the observer, to play around
# but finish at the "Load Charts" tab before going further
iex> :observer.start
# concurrently read war and peace
iex> Reader.concurrent_read()
# look at those Load Charts. You should see processing on all cores for a brief second
# assign the word count map to a variable
iex> map = Agent.get(:tally, fn state -> state end)
# map now contains the mapping of every word in War and Peace, to the number of
# times that word appeared in the text.
# Get the number of times "war" was said
iex> Map.get(map, "war") # 298
# Get the number of times "peace" was said
iex> Map.get(map, "peace") # 113
```