-- do not enable for now
if true then
  return {}
end

local keymap = require("util").keymap

-- TODO: solving searching slowly
-- lvim.builtin.telescope.defaults.path_display = { shorten = 5 }

-- TODO: test generate tag
-- nmap <F9> :call RunShell("Generate tags", "ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .")<cr>
local function plugin_setup_gutentags()
  vim.cmd([[
    let g:gutentags_add_default_project_roots = 0
    " Stop searching when found markers listed below
    let g:gutentags_project_root = ['.root']
    let g:gutentags_ctags_tagfile = '.tags'
    let s:vim_tags = expand('~/.LfCache/ctags')
    let g:gutentags_cache_dir = s:vim_tags
    " if isdirectory("kernel/") && isdirectory("mm/")
    "     let g:gutentags_file_list_command = 'find arch/arm* arch/riscv block crypto drivers fs include init ipc kernel lib mm net security sound virt'
    " endif
    if !isdirectory(s:vim_tags)
        silent! call mkdir(s:vim_tags, 'p')
    endif
    let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
    let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
    let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
  ]])
end

-- TODO test leaderf functionality
-- leaderF, mapped to <leader>a
local function plugin_setup_leaderf()
  vim.cmd([[
    " https://retzzz.github.io/dc9af5aa/
    let g:Lf_Ctags="ctags"
    let g:Lf_WorkingDirectoryMode = 'AF'
    let g:Lf_RootMarkers = ['.root']
    let g:Lf_UseVersionControlTool=1 "default value, can ignore
    let g:Lf_DefaultExternalTool='rg'
    let g:Lf_PreviewInPopup = 1
    " let g:Lf_WindowHeight = 0.30
    " let g:Lf_CacheDirectory = s:cachedir
    "let g:Lf_StlColorscheme = 'powerline'
    let g:Lf_PreviewResult = {
            \ 'File': 0,
            \ 'Buffer': 1,
            \ 'Mru': 0,
            \ 'Tag': 1,
            \ 'BufTag': 1,
            \ 'Function': 1,
            \ 'Line': 1,
            \ 'Colorscheme': 0,
            \ 'Rg': 0,
            \ 'Gtags': 1
            \}
    let g:Lf_GtagsAutoGenerate = 0
    let g:Lf_GtagsGutentags = 1
    "let g:Lf_GtagsAutoGenerate = 1
    "let g:Lf_Gtagslabel = 'native-pygments'
    "let g:Lf_GtagsSource = 1
    let g:Lf_ShortcutF = '<c-p>'
    let g:Lf_ShortcutB = '<c-l>'
    noremap <leader>a :LeaderfSelf<cr>
    noremap <leader>am :LeaderfMru<cr>
    noremap <leader>af :LeaderfFunction<cr>
    noremap <leader>ab :LeaderfBuffer<cr>
    noremap <leader>at :LeaderfBufTag<cr>
    noremap <leader>al :LeaderfLine<cr>
    noremap <leader>aw :LeaderfWindow<cr>
    noremap <leader>arr :LeaderfRgRecall<cr>
    nmap <unique> <leader>ar <Plug>LeaderfRgPrompt
    nmap <unique> <leader>ara <Plug>LeaderfRgCwordLiteralNoBoundary
    nmap <unique> <leader>arb <Plug>LeaderfRgCwordLiteralBoundary
    nmap <unique> <leader>arc <Plug>LeaderfRgCwordRegexNoBoundary
    nmap <unique> <leader>ard <Plug>LeaderfRgCwordRegexBoundary
    vmap <unique> <leader>ara <Plug>LeaderfRgVisualLiteralNoBoundary
    vmap <unique> <leader>arb <Plug>LeaderfRgVisualLiteralBoundary
    vmap <unique> <leader>arc <Plug>LeaderfRgVisualRegexNoBoundary
    vmap <unique> <leader>ard <Plug>LeaderfRgVisualRegexBoundary
    nmap <unique> <leader>agd <Plug>LeaderfGtagsDefinition
    nmap <unique> <leader>agr <Plug>LeaderfGtagsReference
    nmap <unique> <leader>ags <Plug>LeaderfGtagsSymbol
    nmap <unique> <leader>agg <Plug>LeaderfGtagsGrep
    vmap <unique> <leader>agd <Plug>LeaderfGtagsDefinition
    vmap <unique> <leader>agr <Plug>LeaderfGtagsReference
    vmap <unique> <leader>ags <Plug>LeaderfGtagsSymbol
    vmap <unique> <leader>agg <Plug>LeaderfGtagsGrep
    noremap <leader>ago :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
    noremap <leader>agn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
    noremap <leader>agp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
  ]])
end

return {
  {
    -- only work for Neovim version < 0.9.0
    "ukyouz/vim-gutentags",
    enabled = true,
    event = "VeryLazy",
    branch = "improve_update_perf",
    ft = {
      "c",
      "cpp",
      "cmake",
      "makefile",
    },
    init = plugin_setup_gutentags,
  },
  {
    "Yggdroot/LeaderF",
    event = "VimEnter",
    enabled = true,
    init = plugin_setup_leaderf,
    build = ":LeaderfInstallCExtension",
  },
}
