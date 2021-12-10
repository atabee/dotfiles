# local environment dependent settings
[ -s "${ZDOTDIR}/local.zsh" ] && source "${ZDOTDIR}/local.zsh"

# prezto
[ -s "${ZDOTDIR}/.zprezto/init.zsh" ] && source "${ZDOTDIR}/.zprezto/init.zsh"

# envs
[ -s "${ZDOTDIR}/env.zsh" ] && source "${ZDOTDIR}/env.zsh"

# options
[ -s "${ZDOTDIR}/options.zsh" ] && source "${ZDOTDIR}/options.zsh"

# os dependent settings
[ -s "${ZDOTDIR}/os/$(uname).zsh" ] && source "${ZDOTDIR}/os/$(uname).zsh"

# functions
for func (${ZDOTDIR}/functions/*) source $func:a

# zsh completion
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

# zsh site-functions
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh/site-functions $fpath)
fi
