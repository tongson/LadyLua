module github.com/tongson/LadyLua

go 1.16

require (
	git.mills.io/prologic/bitcask v0.3.14
	github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e
	github.com/frankban/quicktest v1.13.0 // indirect
	github.com/fsnotify/fsnotify v1.4.9
	github.com/ghodss/yaml v1.0.0
	github.com/go-redis/redis/v8 v8.11.0
	github.com/go-sql-driver/mysql v1.6.0
	github.com/go-telegram-bot-api/telegram-bot-api v4.6.4+incompatible
	github.com/gregdel/pushover v1.1.0
	github.com/hashicorp/go-uuid v1.0.2
	github.com/junhsieh/goexamples v0.0.0-20210713004924-3d9f14ba676d
	github.com/kevinburke/ssh_config v1.1.0
	github.com/oklog/ulid/v2 v2.0.2
	github.com/pelletier/go-toml v1.9.3
	github.com/pierrec/lz4 v2.6.1+incompatible
	github.com/rs/zerolog v1.23.0
	github.com/segmentio/ksuid v1.0.4
	github.com/slack-go/slack v0.9.3
	github.com/technoweenie/multipartstreamer v1.0.1 // indirect
	github.com/tongson/gl v0.0.0-20210722053448-dfbc7abd31bf
	github.com/yuin/gluamapper v0.0.0-20150323120927-d836955830e7
	github.com/yuin/gopher-lua v0.0.0-20210529063254-f4c35e4016d9
)

replace github.com/yuin/gopher-lua => github.com/tongson/gopher-lua v0.0.0-20210610051759-53ab9600e09f
