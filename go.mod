module github.com/tongson/LadyLua

go 1.16

require (
	github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e
	github.com/frankban/quicktest v1.11.3 // indirect
	github.com/fsnotify/fsnotify v1.4.9
  github.com/ghodss/yaml v1.0.1-0.20190212211648-25d852aebe32
	github.com/go-redis/redis/v8 v8.8.0
	github.com/go-sql-driver/mysql v1.6.0 // indirect
	github.com/go-telegram-bot-api/telegram-bot-api v4.6.4+incompatible
	github.com/gregdel/pushover v0.0.0-20210420080121-f84e8ffafef5
	github.com/hashicorp/go-uuid v1.0.1
	github.com/junhsieh/goexamples v0.0.0-20190721045834-1c67ae74caa6 // indirect
	github.com/mitchellh/mapstructure v1.4.1 // indirect
	github.com/oklog/ulid/v2 v2.0.2
	github.com/pierrec/lz4 v2.6.0+incompatible
	github.com/prologic/bitcask v0.3.10
	github.com/rs/zerolog v1.21.0
	github.com/segmentio/ksuid v1.0.3
	github.com/slack-go/slack v0.9.0
	github.com/technoweenie/multipartstreamer v1.0.1 // indirect
	github.com/yuin/gluamapper v0.0.0-20150323120927-d836955830e7
	github.com/yuin/gopher-lua v0.0.0-20210529063254-53ab9600e90f
)

// replace github.com/yuin/gopher-lua => ./external/gopher-lua
replace github.com/yuin/gopher-lua => github.com/tongson/gopher-lua v0.0.0-20210610051759-53ab9600e09f
