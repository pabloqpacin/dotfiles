local dap, dapui, widgets = require('dap'), require('dapui'), require('dap.ui.widgets')

-- DAP-UI
dapui.setup()
vim.keymap.set('n', '<leader>do', function() dapui.open() end)
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
-- dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
-- dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
vim.keymap.set('n', '<leader>dc', function() dapui.close() end)


-- DAP
vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<F10>', function() dap.step_over() end)
vim.keymap.set('n', '<F11>', function() dap.step_into() end)
vim.keymap.set('n', '<F12>', function() dap.step_out() end)
vim.keymap.set({'n', 'v'}, '<Leader>b', function() dap.toggle_breakpoint() end)
vim.keymap.set({'n', 'v'}, '<Leader>B', function() dap.set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function() widgets.hover() end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function() widgets.preview() end)
vim.keymap.set('n', '<Leader>df', function() widgets.centered_float(widgets.frames) end)
vim.keymap.set('n', '<Leader>ds', function() widgets.centered_float(widgets.scopes) end)
vim.keymap.set('n', '<leader>dt', function() dap.terminate() end)
