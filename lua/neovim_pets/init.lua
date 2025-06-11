local M = {}

math.randomseed(os.time())

local pet = {
  words = 0,
  stage = 1,
  row = 1,
  col = nil,
  width = 0,
  height = 0,
  timer = nil,
  stages = {
    -- Estágio 1: carinha simples
    {" (o.o) "},

    -- Estágio 2: corpo pequeno
    {" (o.o) ", "/(   )\\"},

    -- Estágio 3: pequeno lagarto
    {
      "   _.--.",
      " ,'     `.",
      "/  .- -.  \\",
      "| ( o o ) |",
      "|  `---'  |",
      " \\       /",
      "  `.___.'~",
    },

    -- Estágio 4: ASCII art inspirada no Charmander
    {
      "              _.--\"\"`-..",
      "            ,'          `.",
      "          ,'          __  `.",
      "         /|          \" __   \\",
      "        , |           / |.   .",
      "        |,'          !_.'|   |",
      "      ,'             '   |   |",
      "     /              |`--'|   |",
      "    |                `---'   |",
      "     .   ,                   |",
      "      ._     '           _'  |",
      "  `.. `.`-...___,...---''    ._",
      "   `-._`--'          ____,.-'",
      "       `--..____..--'",
    },
  }
}

local config = {
  message_delay = 5,
}

local last_message_time = 0

local messages = {
  "Que bom te ver digitando bastante! Continue assim e vamos nos divertir muito! 😊",
  "Continue digitando sem pressa, cada palavra conta para a evolução do nosso amiguinho virtual. 🐾",
  "Você está arrasando! Não pare agora, ele adora companhia! 😸",
  "Isso aí! Quanto mais você digita, mais animado ele fica. 🎉",
}

local function move_pet()
  if not pet.win or not vim.api.nvim_win_is_valid(pet.win) then
    return
  end
  local max_row = vim.o.lines - pet.height - 2
  local max_col = vim.o.columns - pet.width - 2
  local dr = math.random(-1, 1)
  local dc = math.random(-1, 1)
  pet.row = math.max(0, math.min(pet.row + dr, max_row))
  pet.col = math.max(0, math.min(pet.col + dc, max_col))
  -- nvim_win_set_config requires the 'relative' field when updating a
  -- floating window. Reuse the same setting as when the window was created.
  vim.api.nvim_win_set_config(pet.win, {
    relative = 'editor',
    row = pet.row,
    col = pet.col,
  })
end

local function show_pet()
  local lines = pet.stages[pet.stage]
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local width = 0
  for _, l in ipairs(lines) do
    if #l > width then width = #l end
  end
  pet.width = width
  pet.height = #lines
  if not pet.col then
    pet.col = vim.o.columns - width - 2
  end
  local opts = {
    relative = 'editor',
    row = pet.row,
    col = pet.col,
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
  if not pet.timer then
    pet.timer = vim.loop.new_timer()
    pet.timer:start(1000, 1000, vim.schedule_wrap(move_pet))
  end
end

local function random_message()
  local now = os.time()
  if now - last_message_time < config.message_delay then
    return
  end
  last_message_time = now
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

function M.setup(opts)
  opts = opts or {}
  if opts.message_delay then
    config.message_delay = opts.message_delay
  end
  vim.api.nvim_create_autocmd('TextChangedI', {
    callback = function()
      local line = vim.api.nvim_get_current_line()
      check_word(line)
    end,
  })
  show_pet()
end

return M

