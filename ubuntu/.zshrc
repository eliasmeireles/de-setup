if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git z colored-man-pages zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export FLUTTER_PATH=":$HOME/Development/flutter"
export PATH="$PATH:$FLUTTER_PATH/bin"
export PATH="$PATH:$FLUTTER_PATH/.pub-cache/bin"

alias chrome="setsid google-chrome &>/dev/null"
alias localServer="ssh eliasferreira@developerserver.local"

# Zip
alias tar-unzip="tar -xvzf"
alias tar-zip="tar cvfz"

# Kubernetes
alias kgp="kubectl get pods"
alias kgc="kubectl get configmap"
alias kgh="kubectl get hpa"
alias kgs="kubectl get svc"
alias kgn="kubectl get nodes"
alias ka="kubectl apply -f"
alias kds="kubectl describe svc"
alias kdp="kubectl describe pods"
alias kdn="kubectl describe nodes"
alias kdc="kubectl describe configmap"
alias klf='r(){kubectl logs -f -l app="$1" --since=2h --tail=1000};r'

# Maven
alias mcis="mvn clean install -Dmaven.test.skip=true"
alias mcps="mvn clean package -Dmaven.test.skip=true"
alias mcp="mvn clean package"
alias mci="mvn clean install"

alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"

export ANDROID_SDK=~/Android/Sdk
export PATH=$PATH:$ANDROID_SDK/platform-tools:$ANDROID_SDK/tools

alias emuList='emulator -avd -list-avds'
alias emuStart='f() {setsid "$ANDROID_SDK/emulator/emulator" -avd $1 -netdelay none -netspeed full &> /dev/null &};f'

# JetBrains ToolBox
export JET_BRAINS_TOOL_BOX="/opt/jet-brains/"
export PATH="$PATH:$JET_BRAINS_TOOL_BOX:$JET_BRAINS_TOOL_BOX/scripts"
