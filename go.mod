module ll

go 1.16

require (
	github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e
	github.com/yuin/gopher-lua v0.0.0-20200816102855-ee81675732da
	layeh.com/gopher-json v0.0.0-552bb3c4c3bf
	layeh.com/gopher-lfs v0.0.0-d5fb28581d14
)

replace layeh.com/gopher-lfs => ./external/gopher-lfs

replace layeh.com/gopher-json => ./external/gopher-json
