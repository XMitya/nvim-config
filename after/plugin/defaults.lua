local api = vim.api
local g = vim.g
local opt = vim.opt

opt.path:remove "/usr/include"
opt.path:append "**"
-- vim.cmd [[set path=.,,,$PWD/**]] -- Alternatively set the path
