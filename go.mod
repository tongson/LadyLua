module ll

go 1.16

require (
	github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e
	github.com/cjoudrey/gluahttp v0.0.0-25003d9adfa9
	github.com/frankban/quicktest v1.11.3 // indirect
	github.com/fsnotify/fsnotify v1.4.9
	github.com/ghodss/yaml v1.0.1-0.20190212211648-25d852aebe32
	github.com/go-redis/redis/v8 v8.8.0
	github.com/go-sql-driver/mysql v1.6.0 // indirect
	github.com/go-telegram-bot-api/telegram-bot-api v4.6.4+incompatible
	github.com/gregdel/pushover v0.0.0-20210420080121-f84e8ffafef5
	github.com/junhsieh/goexamples v0.0.0-20190721045834-1c67ae74caa6 // indirect
	github.com/microcosm-cc/bluemonday v1.0.5
	github.com/mitchellh/mapstructure v1.4.1 // indirect
	github.com/pierrec/lz4 v2.6.0+incompatible
	github.com/prologic/bitcask v0.3.10
	github.com/rs/zerolog v1.21.0
	github.com/segmentio/ksuid v1.0.3
	github.com/sethvargo/go-password v0.2.0
	github.com/slack-go/slack v0.9.0
	github.com/technoweenie/multipartstreamer v1.0.1 // indirect
	github.com/tengattack/gluacrypto v0.0.0-8bf181b63bba
	github.com/tengattack/gluasql v0.0.0-2e5ed630c4cf
	github.com/yuin/gluamapper v0.0.0-20150323120927-d836955830e7
	github.com/yuin/gopher-lua v0.0.0-20200816102855-ee81675732da
	layeh.com/gopher-json v0.0.0-552bb3c4c3bf
	layeh.com/gopher-lfs v0.0.0-d5fb28581d14
)

replace layeh.com/gopher-lfs => ./external/gopher-lfs

replace layeh.com/gopher-json => ./external/gopher-json

replace github.com/cjoudrey/gluahttp => ./external/gluahttp

replace github.com/tengattack/gluacrypto => ./external/gluacrypto

replace github.com/tengattack/gluasql => ./external/gluasql
