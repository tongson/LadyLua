module ll

go 1.16

require (
	github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e
	github.com/cjoudrey/gluahttp v0.0.0-25003d9adfa9
	github.com/cosmotek/loguago v0.0.0-76d2a8755751
	github.com/rs/zerolog v1.21.0
	github.com/tengattack/gluacrypto v0.0.0-8bf181b63bba
	github.com/yuin/gopher-lua v0.0.0-20200816102855-ee81675732da
	layeh.com/gopher-json v0.0.0-552bb3c4c3bf
	layeh.com/gopher-lfs v0.0.0-d5fb28581d14
)

replace layeh.com/gopher-lfs => ./external/gopher-lfs

replace layeh.com/gopher-json => ./external/gopher-json

replace github.com/cjoudrey/gluahttp => ./external/gluahttp

replace github.com/tengattack/gluacrypto => ./external/gluacrypto

replace github.com/cosmotek/loguago => ./external/loguago
