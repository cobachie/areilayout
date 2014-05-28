# Areilayout

AreiCMSの標準レイアウトを設定します.

## Installation

Add this line to your application's Gemfile:

    gem 'areilayout'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install areilayout

## Usage

#### 1.Change directory

    $ cd RAILS_ROOT
    
#### 2.Type code below

- localにあるテンプレートファイルをコピーする場合  

    `$ areilayout set -n LAYOUT_NAME -p SOURCE_PATH`

- 指定したURLからテンプレートファイル(*.zip)をダウンロードする場合  

    `$ areilayout get -n LAYOUT_NAME -p SOURCE_URI`


## Contributing

1. Fork it ( https://github.com/cobachie/areilayout/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
