if [ ! -f ~/.dev_path ]; then
  read -p "enter the root of your dev directory (~/dev) / your path: " devpath
  if [ ${#devpath} -eq 0 ]; then
    echo '~/dev' > ~/.dev_path
  else
    echo ${devpath} > ~/.dev_path
  fi
  export DEV_PATH=devpath
  echo "Your dev path has been set. If you need to update it, update ~/.dev_path"
fi
export DEV_PATH=$(cat ~/.dev_path)
export PATH=$DEV_PATH/web-pubplatform/node_modules/.bin:$PATH

install_homebrew ()
{
  if [ type -p brew ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &> dev/null
    if [[ $? -ne 0 ]] ; then
      echo "homebrew install failed..."
      echo "No 🍺 for you! \n" if MacOS.version >= :lion
    fi
  fi
}

setupBashCompletion ()
{
  . $(brew --prefix)/etc/bash_completion
  GIT_PS1_SHOWDIRTYSTATE=true
  export PS1='[\u@mbp \w$(__git_ps1)]\$ '
}

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  setupBashCompletion
else
  read -p choice 'You do not have bash completion installed, would you like to install it now? (Y)/n: '
  if [ "$choice" = "n" ]; then
    echo "That\'s fine, but, you really should install bash_completion.  To install in the future, run \'brew install bash_completion\'"
    export PS1='[\u@mbp \w]\$ '
  else
    if [ type -p brew ]; then
      setupBashCompletion
    else
        read -p "homebrew is not installed.  Would you like to install homebrew? (Y)/n:" installhomebrew
        if [ "$installhomebrew" = "n" ]; then
          echo "That\'s fine, but, you really should install homebrew.  To install in the future, run \"\'/usr/bin/ruby -e \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"\'"
        else
          install_homebrew && brew install bash_completion
        fi
    fi
  fi
fi


alias gs='git status'
alias gl="git log --pretty=format:'%C(yellow)%h %C(green)%ad%x08%x08%x08%x08%x08%x08%x08%x08%x08 %C(yellow)[%an] %C(green)%s%d' --date=iso"
alias gd='git diff'
alias gp='git cherry-pick'
alias ll='ls -larth'

alias vg="cd $DEV_PATH/unified-reporting/src/test/resources && vagrant halt && vagrant up &"
alias vssh='vagrant ssh -- -R 8090:localhost:8090'

alias urs="cd $DEV_PATH/unified-reporting && mvn -Dspring.profiles.active=vagrant spring-boot:run"

alias bld="cd $DEV_PATH/web-pubplatform && npm run build:feature8.test"
alias srv="cd $DEV_PATH/web-pubplatform && npm run serve:feature8.test"
alias bs='bld && srv'

alias bd='npm run build:dev'
alias sd='npm run serve:dev'
alias dv="cd $DEV_PATH/web-pubplatform && bd && sd"

echo '
  ________        __    __________                   .___         __           __________               __   ._._._.
 /  _____/  _____/  |_  \______   \ ____ _____     __| _/__.__. _/  |_  ____   \______   \ ____   ____ |  | _| | | |
/   \  ____/ __ \   __\  |       _// __ \\__  \   / __ <   |  | \   __\/  _ \   |       _//  _ \_/ ___\|  |/ / | | |
\    \_\  \  ___/|  |    |    |   \  ___/ / __ \_/ /_/ |\___  |  |  | (  <_> )  |    |   (  <_> )  \___|    < \|\|\|
 \______  /\___  >__|    |____|_  /\___  >____  /\____ |/ ____|  |__|  \____/   |____|_  /\____/ \___  >__|_ \______
        \/     \/               \/     \/     \/      \/\/                             \/            \/     \/\/\/\/
'
