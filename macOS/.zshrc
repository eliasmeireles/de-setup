# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_DISABLE_COMPFIX=true

plugins=(
  git
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

export TERM=xterm-256color

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export FLUTTER_PATH=":$HOME/Development/flutter"
export PATH="$PATH:$FLUTTER_PATH/bin"
export PATH="$PATH:$FLUTTER_PATH/.pub-cache/bin"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-19.jdk/Contents/Home"
export PATH="$PATH:$JAVA_HOME"

export KAFKA_PATH="$HOME/Development/Kafka/kafka_2.13-2.8.0"
export PATH="$PATH:$KAFKA_PATH"

export M2_HOME="$HOME/Development/Apache/apache-maven-3.8.4"
export PATH="$PATH:$M2_HOME/bin"

# Docker
alias dlist="docker image ls"
alias dp="docker ps"
alias dpa="docker ps -a"
alias dcrm="docker container rm"
alias dcrmf="docker container rm -f"
alias dexec="docker exec -it"
# Copy from docker container example: dcopy my-container:/app/app.yaml
alias dcopy="docker cp"
alias dlf="docker logs -f"
alias dl="docker logs"
alias dirm="docker image rm"
alias dirmf="docker image rm -f"
alias ds="docker save -o"

# Docker compose
alias dcb="docker-compose up --build -d"
alias dcbf="docker-compose up --build -d --force-recreate"
alias dclf="docker-compose logs -f"
alias dcl="docker-compose logs"
alias dck="docker-compose kill"

# Zip
alias tar-unzip="tar -xvzf"
alias tar-zip="tar cvfz"

alias clearPort='f(){sudo kill -9 $(sudo lsof -t -i:"$1")};f'

# Zip
alias tar-unzip="tar -xvzf"
alias tar-zip="tar cvfz"

# Kubernetes
alias kubExec='f(){kubectl exec --stdin --tty $1 -- /bin/bash}; f'
alias k='kubectl'
# Streamar logs das pods apartir do namespace getLogsF -lapp service-name
alias getLogsF='kubectl logs -f --since=12h --tail=1000000 --max-log-requests=15'
# Streamar logs das pods com prefixo da pod apartir do namespace exemplo: getLogsFP -lapp service-name
alias getLogsFP='kubectl logs -f --since=12h --tail=1000000 --prefix=true --max-log-requests=15'
alias kubDescServices="kubectl describe svc"
alias kubDescPods="kubectl describe pods"
alias kubDescNodes="kubectl describe nodes"
alias kubDescConfig="kubectl describe configmap"
alias getNodes="kubectl get nodes"
alias kubApply="kubectl apply -f"
alias getServices="kubectl get svc"
alias getConfigMaps="kubectl get configmap"
alias getPods='kubectl get pods'
alias getHpa='kubectl get hpa'
alias getDeployments='kubectl get deployments'
alias uatContext='kubectl config use-context uat'
alias prdContext='kubectl config use-context prd'
alias getJobs='kubectl get pods -n jobs'
# Localizar jobs apartir de um nome exemplo: findJobs some-text-in-pode-name
alias findJobs='kubectl get pods -n jobs | grep'
# Localizar jobs apartir de um nome exemplo: findPods some-text-in-pode-name
alias findPods='kubectl get pods | grep'
# Criar um job manual apartir do namespace exemplo: createJob service-name
alias createJob='f(){kubectl create job -n jobs --from="cronjob/$1" "$1-ef$(date +%H%M)"}; f $@'
# Streamar logs das pods com prefixo da pod apartir do namespace, e abrir o arquivo no vs code, exemplo: getLogsCode service-name
alias getLogsCode='log(){code ~/Downloads/"$1".log && kubectl logs -f --since=12h --tail=1000000 --prefix=true --max-log-requests=15 -lapp=$1  > ~/Downloads/"$1".log}; log'
# Obter os logs de um job exemplo: getJobLogs pode-name
alias getJobLogs='kubectl logs  -n jobs'

# Git
alias gs="git status"
alias gsi="git submodule update --init"
alias gsp="git pull && git submodule foreach --recursive 'git pull ; sleep 1'"
alias gsf="git fetch && git submodule foreach --recursive 'git fetch ; sleep 1'"
alias gss="git status && git submodule foreach --recursive 'git status ; sleep 1'"
alias gsclean="git remote prune origin && git submodule foreach --recursive 'git remote prune origin ; sleep 1'"


alias kafkaTopic="$KAFKA_PATH/bin/kafka-topics.sh"
alias kafkaTopicsList="$KAFKA_PATH/bin/kafka-topics.sh --list  --bootstrap-server localhost:9092"
alias kafkaConsoleProducer="$KAFKA_PATH/bin/kafka-console-producer.sh"

alias emuList='emulator -avd -list-avds'
alias emuStart='f() {nohup ./Library/Android/sdk/emulator/emulator -avd $1 -netdelay none -netspeed full &> /dev/null &};f'

export ANDROID_NDK=~/Library/Android/ndk
export ANDROID_SDK=~/Library/Android/sdk

export PATH=$PATH:$ANDROID_SDK/platform-tools:$ANDROID_SDK/tools
