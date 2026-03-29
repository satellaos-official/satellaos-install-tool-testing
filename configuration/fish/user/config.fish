# ~/.config/fish/config.fish
# .bashrc'den taşındı (SatellaOS / Kali stili)

# ── Geçmiş ayarları ───────────────────────────────────────────────────────────
# Fish geçmişi otomatik yönetir; ayrıca ayar gerekmez.
# Yinelenen komutları atlamak için:
set -g fish_history_duplicates erase

# ── Environment değişkenleri ──────────────────────────────────────────────────
set -x EDITOR nano
set -x VISUAL nano
set -x GTK_IM_MODULE uim
set -x QT_IM_MODULE uim
set -x XMODIFIERS @im=uim

fish_add_path /sbin /usr/sbin

set -x XDG_DATA_DIRS /var/lib/flatpak/exports/share $HOME/.local/share/flatpak/exports/share $XDG_DATA_DIRS

# ── Renk desteği ──────────────────────────────────────────────────────────────
if test -x /usr/bin/dircolors
    if test -r ~/.dircolors
        eval (dircolors -c ~/.dircolors)
    else
        eval (dircolors -c)
    end
end

set -x LS_COLORS "$LS_COLORS:ow=30;44:"

# less renkleri (man sayfaları için)
set -x LESS_TERMCAP_mb \e'[1;31m'
set -x LESS_TERMCAP_md \e'[1;36m'
set -x LESS_TERMCAP_me \e'[0m'
set -x LESS_TERMCAP_so \e'[01;33m'
set -x LESS_TERMCAP_se \e'[0m'
set -x LESS_TERMCAP_us \e'[1;32m'
set -x LESS_TERMCAP_ue \e'[0m'

# ── Alias'lar ─────────────────────────────────────────────────────────────────
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias fastfetch='fastfetch --logo-color-1 "38;2;127;63;191" --logo /usr/share/SatellaOS/logo/ASCII\ Art/SatellaOS.asc'

# ── Prompt (Kali/SatellaOS stili, iki satır) ──────────────────────────────────
# Fish'in kendi prompt sistemi fonksiyon tabanlıdır.
# Aşağıdaki fish_prompt fonksiyonu .bashrc'deki PS1 twoline stilini taklit eder.

function fish_prompt
    set -l last_status $status

    # Root mu normal kullanıcı mı?
    if test $EUID -eq 0
        set -l pc (set_color 5f87ff)        # mavi (root prompt)
        set -l ic (set_color --bold red)    # kırmızı (root info)
        set -l nc (set_color normal)

        set -l venv_str ''
        if set -q VIRTUAL_ENV
            set venv_str $pc"("(set_color --bold white)(basename $VIRTUAL_ENV)$nc$pc")-"
        end

        set -l cwd (prompt_pwd)
        printf "\n"
        printf "%s┌──%s(%s%s%s@%s%s%s)-[%s%s%s]\n" \
            $pc $venv_str $ic (whoami) $nc $ic (hostname) $pc (set_color --bold white) $cwd $nc$pc
        printf "%s└─%s#%s " $pc $ic $nc
    else
        set -l pc (set_color 7f3fbf)             # mor (normal prompt)
        set -l ic (set_color --bold 7f3fbf)      # kalın mor (info)
        set -l nc (set_color normal)

        set -l venv_str ''
        if set -q VIRTUAL_ENV
            set venv_str $pc"("(set_color --bold white)(basename $VIRTUAL_ENV)$nc$pc")-"
        end

        set -l cwd (prompt_pwd)
        printf "\n"
        printf "%s┌──%s(%s%s%s@%s%s%s)-[%s%s%s]\n" \
            $pc $venv_str $ic (whoami) $nc $ic (hostname) $pc (set_color --bold white) $cwd $nc$pc
        printf "%s└─%s\$%s " $pc $ic $nc
    end
end

# Sağ prompt (isteğe bağlı, temiz bırakıldı)
function fish_right_prompt
end