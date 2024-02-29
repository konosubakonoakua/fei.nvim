-- https://wakatime.com/vim
-- https://wakatime.com/settings/api-key
return {
  'wakatime/vim-wakatime',
  -- NOTE: must disable wakatime during github actions
  lazy = require("platform").isPlatGithubAction(),
}

