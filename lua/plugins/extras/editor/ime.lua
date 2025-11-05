if vim.fn.has("pythonx") == 0 then
  LazyVim.error("Python not found, IME won't be loaded. Please run `:checkhealth provider.python`.")
  return {}
end

function setup()
  if jit.os == "Windows" then
    vim.cmd([[
    py import win32api, win32gui
    py from win32con import WM_INPUTLANGCHANGEREQUEST
  ]])

    local ime_switch = function(mode)
      if mode == "en" then
        return vim.fn.pyeval(
          "win32api.SendMessage(win32gui.GetForegroundWindow(), WM_INPUTLANGCHANGEREQUEST, 0, 0x0409)"
        )
      elseif mode == "zh" then
        return vim.fn.pyeval(
          "win32api.SendMessage(win32gui.GetForegroundWindow(), WM_INPUTLANGCHANGEREQUEST, 0, 0x0804)"
        )
      else
        return -1
      end
    end

    vim.api.nvim_create_autocmd({ "VimEnter", "InsertLeave" }, {
      pattern = "*",
      callback = function(ev)
        ime_switch("en")
      end,
    })

    vim.api.nvim_create_autocmd({ "VimLeave", "InsertEnter" }, {
      pattern = "*",
      callback = function(ev)
        ime_switch("zh")
      end,
    })
  else -- unix, macos
    -- TODO: add linux ime
  end
end

-- delay 100ms
vim.defer_fn(setup, 100)

-- avoid load multiple times
setup = function () end

return {}
