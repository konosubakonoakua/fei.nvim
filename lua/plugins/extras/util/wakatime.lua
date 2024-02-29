-- https://wakatime.com/vim
-- https://wakatime.com/settings/api-key
return {
  'wakatime/vim-wakatime',
  -- NOTE: must disable wakatime during github actions
  -- NOTE better to keep vpn running in order to update cli
  lazy = require("platform").isPlatGithubAction(),
}

