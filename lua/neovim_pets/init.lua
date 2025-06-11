local M = {}

math.randomseed(os.time())

local pet = {
  words = 0,
  stage = 1,
  stages = {
    {" (^_^) "},
    {" /\\_/\\ ", "( o.o )"},
    {"  /\\_/\\  ", " ( o.o ) ", "  > ^ < "},
    {"  /\\_/\\  ", " ( o.o ) ", "  > ^ < ", " /     \\"},
  }
}

local messages = {
  "Vamos brincar! 😊",
  "Continue digitando! 🐾",
  "Você está arrasando! 😸",
  "Isso aí! 🎉",
}

local function show_pet()
  local lines = pet.stages[pet.stage]
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local width = 0
  for _, l in ipairs(lines) do
    if #l > width then width = #l end
  end
  local opts = {
    relative = 'editor',
    row = 1,
    col = vim.o.columns - width - 2,
    width = width,
    height = #lines,
    style = 'minimal',
    focusable = false,
    border = 'none',
  }
  if pet.win and vim.api.nvim_win_is_valid(pet.win) then
    vim.api.nvim_win_close(pet.win, true)
  end
  pet.win = vim.api.nvim_open_win(buf, false, opts)
end

local function random_message()
  local msg = messages[math.random(#messages)]
  vim.api.nvim_echo({{msg}}, false, {})
end

local function update_stage()
  local thresholds = {10, 20, 40}
  for i, t in ipairs(thresholds) do
    if pet.words >= t then
      pet.stage = math.min(i + 1, #pet.stages)
    end
  end
  show_pet()
end

local function check_word(line)
  if line:sub(-1) == ' ' or line:sub(-1) == '\n' then
    pet.words = pet.words + 1
    update_stage()
    random_message()
  end
end

function M.setup()
  vim.api.nvim_create_autocmd('TextChangedI', {
    callback = function()
      local line = vim.api.nvim_get_current_line()
      check_word(line)
    end,
  })
  show_pet()
end

return M

