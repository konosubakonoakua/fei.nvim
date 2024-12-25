local icon_kinds = LazyVim.config.icons.kinds

return {
  -- nvim-cmp icon customize
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      opts.window = {
        completion = {
          border = "none",
          scrollbar = nil,
          -- winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
          col_offset = 0,
          side_padding = 0,
        },
      }
      ------ https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
      opts.formatting.fields = { "kind", "abbr", "menu" }
      opts.formatting.format = function(_, item)
        -- item.menu = item.kind
        if icon_kinds[item.kind] then
          item.kind = " " .. icon_kinds[item.kind] -- .. " "
        end
        return item
      end
    end,
  },

  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      fuzzy = {
        use_typo_resistance = true,
        use_frecency = true,
        use_proximity = true,
        sorts = { "score", "sort_text" },
        prebuilt_binaries = {
          download = true,
          ignore_version_mismatch = false,
          force_version = nil,
          force_system_triple = nil,
          -- NOTE: for watt-toolkit hosts
          extra_curl_args = { "--ssl-no-revoke" },
        },
      },
    },
  },
}
