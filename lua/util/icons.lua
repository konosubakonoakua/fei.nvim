return {
  mode = {
    n = "", -- Normal
    -- no = "", -- Operator-pending
    -- nov = "", -- Operator-pending (forced charwise |o_v|)
    -- noV = "", -- Operator-pending (forced linewise |o_V|)
    -- ="",-V Operator-pending (forced blockwise |o_CTRL-V|)
    -- CTRL-V is one character
    -- niI = "", -- Normal using |i_CTRL-O| in |Insert-mode|
    -- niR = "", -- Normal using |i_CTRL-O| in |Replace-mode|
    -- niV = "", -- Normal using |i_CTRL-O| in |Virtual-Replace-mode|
    -- nt = "", -- Normal in |terminal-emulator| (insert goes to
    -- Terminal mode)
    -- ntT = "", -- Normal using |t_CTRL-\_CTRL-O| in |Terminal-mode|
    v = "", -- Visual by character
    -- vs = "󱇚", -- Visual by character using |v_CTRL-O| in Select mode
    V = "", -- Visual by line
    -- Vs = "󱇚", -- Visual by line using |v_CTRL-O| in Select mode
    [''] = "󱇚",
    -- CTRL-V   Visual blockwise
    -- CTRL-Vs  Visual blockwise using |v_CTRL-O| in Select mode
    s = "", -- Select by character, used in native snippets for neovim >= 0.10.0
    -- S = "", -- Select by line, currentlly not used
    -- CTRL-S   Select blockwise
    i = "", -- Insert
    -- ic = "", -- Insert mode completion |compl-generic|
    -- ix = "", -- Insert mode |i_CTRL-X| completion
    R = "", -- Replace |R|
    -- Rc = "", -- Replace mode completion |compl-generic|
    -- Rx = "", -- Replace mode |i_CTRL-X| completion
    -- Rv = "", -- Virtual Replace |gR|
    -- Rvc = "", -- Virtual Replace mode completion |compl-generic|
    -- Rvx = "", -- Virtual Replace mode |i_CTRL-X| completion
    c = "", -- Command-line editing
    -- cv = "", -- Vim Ex mode |gQ|
    -- r = "", -- Hit-enter prompt
    -- rm = "", -- The -- more -- prompt
    -- ="", -- ?	    A |:confirm| query of some sort
    -- !="", -- Shell or external command is executing
    t = "", -- Terminal mode: keys go to the job
  },
  dap = {
    Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = ".>",
  },
  diagnostics = {
    Error = " ", -- 
    Warn =  " ", -- 
    Hint =  "󱩏 ", -- 󱠂 󰟶 󰟷    
    Info =  " ", -- 
  },
  git = {
    added =     " ", -- 
    modified =  " ", -- 
    removed =   " ", -- 
  },
  kinds = {
    Array =          " ",
    Boolean =        " ",
    Class =          " ", -- 󱁉
    Color =          " ",
    Constant =       " ",
    Constructor =    " ", -- 󰈏 
    Copilot =        " ",
    Enum =           " ",
    EnumMember =     " ",
    Event =          " ",
    Field =          " ",
    File =           " ",
    Folder =         " ",
    Function =       "󰊕 ",
    Interface =      " ",
    Key =            " ", -- 
    Keyword =        " ",
    Method =         " ",
    Module =         " ",
    Namespace =      " ",
    Null =           "󰟢 ", -- 
    Number =         "󰎠 ",
    Object =         " ",--  
    Operator =       " ",
    Package =        " ",
    Property =       " ",
    Reference =      " ",
    Snippet =        " ",
    String =         " ",
    Struct =         " ",
    Text =           " ",
    TypeParameter =  " ",
    Unit =           "󰳂 ",
    Value =          " ",
    Variable =       " ",
  },
  todo = {
    bug = " ",
    todo = " ",
    hack = " ",
    warn = " ",
    perf = " ",
    note = "󰍦 ",
    test = "󰙨 ",
  },
  fold = {
    fold = "",
  },
  lualine = {
     branch= {
      branch_v1 = "",
      branch_v2 = "",
      folder = "",
      git = "󰊢",
    },
    filename = {
      modified = "󰇥", -- 
      readonly = "󰍁",
      unnamed = "󰩃", -- 󱩡 󰻭
    },
    fileformat = {
      unix = "",
      dos = "",
      win = "",
      mac = "",
    },
  },
  emoji = {
    tomato = "🍅",
  },
}
