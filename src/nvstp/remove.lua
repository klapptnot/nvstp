-- uninstall function
--  It would be sad to run this :(

local function uninstall_nvstp(all)
  local fcall = require("warm.spr").fcall

  local folders = {
    vim.fn.stdpath("config"),
  }
  if all == true then
    table.insert(folders, vim.fn.stdpath("data"))
    table.insert(folders, vim.fn.stdpath("cache"))
  end

  local function f(rv, ...)
    local args = { ... }
    print("Error removing folder:", args[1])
    print("Error message:", rv[1])
  end

  for _, folder in ipairs(folders) do
    local _ = fcall(f, vim.fn.delete, folder, "rf")
  end
end

vim.api.nvim_create_user_command("NvstpRemove", function()
  vim.ui.select({ "Yes", "No" }, {
    prompt = "Are you sure you want to remove all configurations?",
  }, function(choice)
    if choice == "Yes" then
      vim.ui.select({ "Yes", "No" }, {
        prompt = "Do you want to remove all chached data?",
      }, function(choice2)
        if choice2 == "Yes" then
          uninstall_nvstp(true)
        else
          uninstall_nvstp()
        end
      end)
    else
      vim.api.nvim_echo({ { "I was scared, puff!", "Bold" } }, false, {})
    end
  end)
end, {
  desc = "Remove nvstp instalation",
})
