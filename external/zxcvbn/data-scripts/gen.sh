
python build_frequency_lists.py ../data ../frequency/lists.go
go fmt ../frequency/lists.go
python build_keyboard_adjacency_graphs.py ../adjacency/graphs.go
go fmt ../adjacency/graphs.go