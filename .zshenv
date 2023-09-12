# 環境固有の設定を読み込む
test -f ~/.zshenv.local && . $_

# 環境変数の設定
export PATH=~/bin:~/.local/bin:$PATH
