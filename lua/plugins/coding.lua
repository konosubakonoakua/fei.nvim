local icon_kinds = LazyVim.config.icons.kinds

return {
  -- nvim-cmp icon customize
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.window = {
        completion = {
          border = "none",
          scrollbar = nil,
          -- winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
          col_offset = 0,
          side_padding = 0,
        }
      }
      ------ https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
      opts.formatting.fields = { "kind", "abbr", "menu" }
      opts.formatting.format = function(_, item)
        -- item.menu = item.kind
        if icon_kinds[item.kind] then
          item.kind = " " .. icon_kinds[item.kind]-- .. " "
        end
        return item
      end
    end,
  },

}
